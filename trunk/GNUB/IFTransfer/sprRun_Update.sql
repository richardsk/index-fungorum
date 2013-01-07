
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprRun_Update')
	BEGIN
		DROP  Procedure  sprRun_Update
	END

GO

CREATE Procedure sprRun_Update
	@providerId uniqueidentifier
AS

	declare @prov nvarchar(150)
	select @prov = providername from admin.Provider where ProviderID = @providerId
		
	if (@prov = 'Index Fungorum') 
	begin
		--check a job is not already in progress	
		declare @status int, @job_Id uniqueidentifier, @js int

		select @job_Id = job_id from msdb..sysjobs_view where name = 'IFToGNUB'
		
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
		    
			select @status = job_state from @xp_results where job_id = @job_Id
		
		if (@status is null or @status = 4)
		begin
			exec msdb.dbo.sp_start_job 'IFToGNUB'
		end
	end


GO


GRANT EXEC ON sprRun_Update TO PUBLIC

GO
