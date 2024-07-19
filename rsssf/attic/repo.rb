


def make_schedules_summary_v0( stats )   ## note: requires stats to be passed in for now
    report = ScheduleReport.new( stats, @opts )   ## pass in title etc.
    report.save( "#{@repo_path}/README.md" )
end  # method make_schedules_summary
  
  