require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'
require 'mongo'

configure do
  set :db, Mongo::Connection.new.db('spikes').collection('todos')
end

get '/' do
  @todos = settings.db.find.to_a
  erb :index
end

post '/' do  
  data = JSON.parse request.body.read  
  settings.db.insert(data)
end

put '/:id' do
  data = JSON.parse request.body.read    
  settings.db.update({'_id' => object_id(params[:id])}, {'$set' => data})
end

delete '/:id' do
  settings.db.remove(:_id => object_id(params[:id]))
end

helpers do
  def object_id val
    BSON::ObjectId.from_string(val)
  end
end