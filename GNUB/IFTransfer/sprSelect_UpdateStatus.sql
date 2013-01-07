
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_UpdateStatus')
	BEGIN
		DROP  Procedure  sprSelect_UpdateStatus
	END

GO

CREATE Procedure sprSelect_UpdateStatus
	@providerId uniqueidentifier
AS

	declare @prov nvarchar(150)
	select @prov = providername from admin.Provider where ProviderID = @providerId
		
	if (@prov = 'Index Fungorum') 
	begin
		--check job status
		
		declare @historyid int, @status nvarchar(100), @msg nvarchar(4000), @job_Id uniqueidentifier
		declare @js int, @complDt datetime, @jid uniqueidentifier

		select @job_Id = job_id from msdb..sysjobs_view where name = 'IFToGNUB'

		set @status = 'In Progress'
		
		  DECLARE @xp_results TABLE (job_id                UNIQUEIDENTIFIER NOT NULL,
									last_run_date         INT              NOT NULL,
									last_run_time         INT              NOT NULL,
									next_run_date         INT              NOT NULL,
									next_run_time         INT              NOT NULL,
									next_run_schedule_id  INT              NOT NULL,
									requested_to_run      INT              NOT NULL, -- BOOL
									request_source        INT              NOT NULL,
									request_source_id     sysname          COLLATE database_default NULL,
									running               INT              NOT NULL, -- BOOL
									current_step          INT              NOT NULL,
									current_retry_attempt INT              NOT NULL,
									job_state             INT              NOT NULL)
		                           
		                           
			DECLARE @job_owner   sysname 
			select @job_owner = SUSER_SNAME()
		    
			INSERT INTO @xp_results    
			EXECUTE master.dbo.xp_sqlagent_enum_jobs 1, @job_owner
		    
			select @js = job_state from @xp_results where job_id = @job_Id
			
		/*select @jid = ja.job_id, @historyid = job_history_id, @complDt = ja.stop_execution_date 
		from msdb..sysjobactivity ja
		inner join msdb..sysjobs_view jv on jv.job_id = ja.job_id
		where name = 'IFToGNUB'

		
		if (@jid is null) --no activity - look up history
		begin
			select top 1 @js = run_status, @msg = [message]			
			from msdb..sysjobhistory jh
			inner join msdb..sysjobs_view jv on jv.job_id = jh.job_id
			where jv.name = 'IFToGNUB'
			order by jh.run_date desc
			
			if (@js is null) set @status = ''
			else if (@js = 0) set @status= 'Failed'
			else set @status = 'Succeeded'
		end*/
		
		if (@js is null) set @status = ''
		else if (@js = 4) --idle, so get last status from history
		begin
			select top 1 @js = run_status, @msg = [message],
				@complDt = CONVERT(DATETIME, RTRIM(run_date)) + ((run_time/10000 * 3600) + ((run_time%10000)/100*60) + (run_time%10000)%100) / (86399.9964 /* Start Date Time */)
				+ ((run_duration/10000 * 3600) + ((run_duration%10000)/100*60) + (run_duration%10000)%100 /*run_duration_elapsed_seconds*/) / (86399.9964 /* seconds in a day*/) 	
			from msdb..sysjobhistory jh
			where jh.job_id = @job_Id
			order by jh.run_date desc, jh.run_time desc
			
			if (@js is null) set @status = ''
			else if (@js = 0) set @status= 'Failed'
			else set @status = 'Succeeded'
		end
		
		/*if (@historyid is not null) -- get history record from activity record
		begin
			select @js = run_status, @msg = [message] from msdb..sysjobhistory where instance_id = @historyid
			if (@js = 0) set @status= 'Failed'
			else set @status = 'Succeeded'
		
		end */


		update admin.UpdateLog 
		set Status = @status, CompleteDate = @complDt 
		where ProviderId = @providerId and 
			StartDate = (select max(startdate) from admin.UpdateLog where ProviderId = @providerId)
		
		select @status, @msg
	end


GO


GRANT EXEC ON sprSelect_UpdateStatus TO PUBLIC

GO
