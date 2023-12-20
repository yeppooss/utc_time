require 'rails_helper'

RSpec.describe "Times", type: :request do
  it 'returns only UTC time' do
    get '/time'
    body = JSON.parse(response.body)
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq("application/json; charset=utf-8")
    expect(body.keys).to contain_exactly('utc')
  end

  it 'returns UTC time, Kyiv and New York time' do
    get '/time', params: {cities: ['Kyiv', 'New York']}
    body = JSON.parse(response.body)
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq("application/json; charset=utf-8")
    expect(body.keys).to eq(%w[Kyiv New\ York utc])
  end
end
