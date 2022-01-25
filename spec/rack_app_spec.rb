describe RackApp do
	let(:response) { get '/' }

	before(:each) do
		HitCounterMiddleware.class_variable_set :@@times, Array.new(300, 0)
		HitCounterMiddleware.class_variable_set :@@hits, Array.new(300, 0)
	end

	it 'returns a status of 200' do
		expect(response.status).to eq(200)
		expect(response.body).to include('Hello from Rack')
	end


	context 'logging middleware' do
		it 'logs the duration of the request' do
			expect(response.body).to include('seconds')
		end
	end


	context 'hit counter middleware' do
		it 'counts hits within a time interval' do
			Timecop.freeze do
				expect(response.body).to include('hits in the last five minutes 1')
			end
		end

		it 'counts multiple hits in succession' do
			Timecop.freeze do
				get '/'
				get '/'
				expect(response.body).to include('hits in the last five minutes 3')
			end
		end


		it 'only counts within a five minute window' do
			Timecop.freeze do
				get '/'
				get '/'
				expect(response.body).to include('hits in the last five minutes 3')
			end

			# go forward 6 minutes
			Timecop.travel(Time.now + 60 * 6) do
				expect(response.body).to include('hits in the last five minutes 1')
			end
		end
	end

end
