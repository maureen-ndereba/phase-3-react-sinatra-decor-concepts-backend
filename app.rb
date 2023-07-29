require 'sinatra'
require 'active_record'
require 'bcrypt'
require 'carrierwave'
require 'carrierwave/orm/activerecord'

# Load models
require_relative 'models/designer'
require_relative 'models/project_proposal'
require_relative 'models/note'

# Configure the database connection
ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: 'db/development.sqlite3' # Update this with your database name if needed
  )
  
  # Configure sessions for user authentication
  enable :sessions
  set :session_secret, 'luna_secret_key' # Change this to a random and secure key
  
  # Helper method to check if a designer is logged in
  def logged_in?
    !!session[:designer_id]
  end
  
  # Helper method to get the current logged-in designer
  def current_designer
    Designer.find_by(id: session[:designer_id]) if logged_in?
  end
  
  # Route to handle designer sign up (create a designer account)
  post '/designers' do
    designer = Designer.new(name: params[:name], email: params[:email], password: params[:password])
    if designer.save
      # Success response: Redirect to a success page or perform other actions
    redirect '/success'
    else
      # Error response: Render the sign-up form again with error messages
    erb :signup, locals: { errors: designer.errors.full_messages }
end
end
  
  # Route to handle designer login
  post '/login' do
    designer = Designer.find_by(email: params[:email])
    if designer && designer.authenticate(params[:password])
      session[:designer_id] = designer.id # Set a session to maintain user login state
       # Success response: Redirect to a dashboard page or perform other actions
    redirect '/dashboard'
else
  # Error response: Render the login page again with an error message
  erb :login, locals: { error_message: "Invalid email or password." }
end
end
  
  # Route to handle designer logout
post '/logout' do
    session.clear # Clear the session to log out the designer
    # Success response: Redirect to the login page after logout
    redirect '/login'
  end

  # Route to view the current designer's profile
get '/designers/:id' do
    designer = Designer.find(params[:id])
    # Success response: Render the designer details using a template (e.g., JSON or an ERB template)
    erb :designer_profile, locals: { designer: designer }
  end
  
  # Route to view the current designer's profile
get '/designers/:id' do
    designer = Designer.find(params[:id])
    # Success response: Render the designer details using a template (e.g., JSON or an ERB template)
    erb :designer_profile, locals: { designer: designer }
  end

  # Route to edit the current designer's profile
patch '/designers/:id' do
    designer = Designer.find(params[:id])
    if designer.update(name: params[:name], email: params[:email])
      # Success response: Redirect to the updated profile page or perform other actions
      redirect "/designers/#{designer.id}"
    else
      # Error response: Render the edit profile form again with error messages
      erb :edit_profile, locals: { designer: designer, errors: designer.errors.full_messages }
    end
  end
  
  
  # Route to delete the current designer's account
delete '/designers/:id' do
    designer = Designer.find(params[:id])
    designer.destroy
    session.clear # Clear the session to log out the designer after account deletion
    # Success response: Redirect to a confirmation page or a relevant page
    redirect '/goodbye'
  end
  
  # Route to create a project proposal for the current designer
post '/designers/:id/project_proposals' do
    designer = Designer.find(params[:id])
    project_proposal = designer.project_proposals.build(title: params[:title], description: params[:description])
    if project_proposal.save
      # Success response: Redirect to the created project proposal page or perform other actions
      redirect "/project_proposals/#{project_proposal.id}"
    else
      # Error response: Render the create project proposal form again with error messages
      erb :create_project_proposal, locals: { errors: project_proposal.errors.full_messages }
    end
  end
  
  # ... Add other routes as needed for viewing, editing, and deleting project proposals and notes ...
  
  # Error handling route for handling 404 (not found) errors
not_found do
    # Return a custom 404 page or error message
    erb :not_found
  end
  
  # Error handling route for handling 500 (internal server) errors
error 500 do
    # Return a custom 500 page or error message
    erb :error_500
  end
  

# Specify the directory where uploaded files will be stored (if using :file storage)
CarrierWave.configure do |config|
  config.root = File.join(__dir__, 'public')
end

# Route to handle avatar upload
post '/designers/:id/avatar' do
    designer = Designer.find(params[:id])
    designer.avatar = params[:avatar] # params[:avatar] should be the file uploaded in the request
    designer.save
    # Return success response or redirect to the designer's profile page
  end
  
  # Route to retrieve the avatar URL for a designer
  get '/designers/:id/avatar' do
    designer = Designer.find(params[:id])
    # Return the avatar URL (e.g., designer.avatar.url)
  end