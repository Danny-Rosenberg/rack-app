class HitCounterMiddleware

	INTERVAL = 300

	@@hits  = Array.new(INTERVAL, 0)
	@@times = Array.new(INTERVAL, 0)

	attr_reader :now

	def initialize(app)
    @app = app
		@now = Time.now.to_i
  end

  def call(env)
		record_hit(INTERVAL)
		status, headers, body = @app.call(env)
		# is this using the same 'now'?
		hits = get_hits(INTERVAL)
		[status, headers, body << "hits in the last five minutes #{hits}:" ]
	end


private


	def record_hit(interval = INTERVAL)
		index = now % interval
		# 'bust the cache' if necessary
		unless now == @@times[index]
			@@times[index] = now
			@@hits[index] = 1
		else
			# we have some simultaneous hits in the current second
			@@hits[index] += 1
		end
	end


	# default to 5 minutes
	def get_hits(seconds = INTERVAL)
		hit_count = 0
		@@times.each_with_index do |time, index|
			# if the value in the times array is within the interval, add it to the count
			if now - time  < seconds
				hit_count += @@hits[index]
			end
		end
		hit_count
	end

end
