# prometheus-ruby

A example for prometheus metrics in ruby with [prometheus/client_ruby](https://github.com/prometheus/client_ruby), the metrics include

- Memory usage
- CPU usage
- Ruby VM GC count

### Installation

```
git clone git@github.com:songjiayang/prometheus-ruby.git
cd prometheus-ruby
bundle install 
```

### Run

```
rackup 
```

We can visit `http://localhost:9292/metrics` to see all the metric data, eg:

```
# TYPE http_requests counter
# HELP http_requests A counter of HTTP requests made
http_requests{app="prome-demo",path="/"} 1.0
http_requests{app="prome-demo",path="/metrics"} 1.0
# TYPE memory_usage gauge
# HELP memory_usage memory usage bytes
memory_usage{app="prome-demo"} 15548.0
# TYPE cpu_usage gauge
# HELP cpu_usage cpu usage percent
cpu_usage{app="prome-demo"} 0.0
# TYPE gc_count gauge
# HELP gc_count vm gc count
gc_count{app="prome-demo",name="total"} 53.0
gc_count{app="prome-demo",name="minor"} 47.0
gc_count{app="prome-demo",name="major"} 6.0
```