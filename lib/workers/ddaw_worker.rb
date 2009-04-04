class DdawWorker < BackgrounDRb::MetaWorker
  set_worker_name :ddaw_worker
  pool_size 3
  def create(args = nil)
    # this method is called, when worker is loaded for the first time
  end
  
  def pooldda(dda)
    thread_pool.defer(:execdda, dda)
  end
  
  def execdda(dda)
    dda.generate
    persistent_job.finish!
  end
end

