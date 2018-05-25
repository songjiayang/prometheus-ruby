require 'prometheus/client'
require 'prometheus/client/formats/text'

require 'rack'

# create a new counter metric
prometheus = Prometheus::Client.registry

defaul_labels = {
  app: "prome-demo"
}

http_requests = Prometheus::Client::Counter.new(:http_requests, 'A counter of HTTP requests made', defaul_labels)
prometheus.register(http_requests)

memory_usage = Prometheus::Client::Gauge.new(:memory_usage, 'memory usage bytes', defaul_labels)
prometheus.register(memory_usage)

cpu_usage = Prometheus::Client::Gauge.new(:cpu_usage, 'cpu usage percent', defaul_labels)
prometheus.register(cpu_usage)

gc_stat = Prometheus::Client::Gauge.new(:gc_count, 'vm gc count', defaul_labels)
prometheus.register(gc_stat)

metric_path = "/metrics".freeze

run ->(env) {
  http_requests.increment({path: env['PATH_INFO']}, 1)
    
  case env['PATH_INFO']
  when metric_path
    memory_usage.set({}, `ps x -o rss #{Process.pid} | tail -1`.strip.to_i)
    cpu_usage.set({}, `ps x -o %cpu #{Process.pid} | tail -1`.strip.to_f)
    
    gc_stat.set({name: "total"}, GC.stat[:count])
    gc_stat.set({name: "minor"}, GC.stat[:minor_gc_count])
    gc_stat.set({name: "major"}, GC.stat[:major_gc_count])
    
    [200, {'Content-Type' => 'text/text'}, [Prometheus::Client::Formats::Text.marshal(prometheus)]] 
  else 
    [200, {'Content-Type' => 'text/html'}, []]
  end
}