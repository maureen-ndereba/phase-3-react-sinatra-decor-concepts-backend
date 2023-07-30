require 'sinatra'
require 'active_record'
require 'bcrypt'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
require_relative '../../uploaders/avatar_uploader'

class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'

  # Load models
  require_relative '../models/designer'
  require_relative '../models/project-proposal'
  require_relative '../models/note'

  # Configure the database connection
  ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: 'db/development.sqlite3' 
  )

  # Configure sessions for user authentication
  enable :sessions
  set :session_secret, 'luna_secret_key' 

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
      { message: 'Designer account created successfully.' }.to_json
    else
      # Error response: Render the error message as JSON
      { error: designer.errors.full_messages }.to_json
    end
  end

  # Route to handle designer login
  post '/login' do
    designer = Designer.find_by(email: params[:email])
    if designer && designer.authenticate(params[:password])
      session[:designer_id] = designer.id # Set a session to maintain user login state
      # Success response: Redirect to a dashboard page or perform other actions
      { message: 'Login successful.' }.to_json
    else
      # Error response: Render the error message as JSON
      { error: 'Invalid email or password.' }.to_json
    end
  end

  # Route to handle designer logout
  post '/logout' do
    session.clear # Clear the session to log out the designer
    # Success response: Redirect to the login page after logout
    { message: 'Logout successful.' }.to_json
  end

  # Route to view the current designer's profile
  get '/designers/:id' do
    designer = Designer.find(params[:id])
    # Success response: Render the designer details as JSON
    designer.to_json
  end

  # Route to edit the current designer's profile
  patch '/designers/:id' do
    designer = Designer.find(params[:id])
    if designer.update(name: params[:name], email: params[:email])
      # Success response: Render the updated profile as JSON
      designer.to_json
    else
      # Error response: Render the error message as JSON
      { error: designer.errors.full_messages }.to_json
    end
  end

  # Route to delete the current designer's account
  delete '/designers/:id' do
    designer = Designer.find(params[:id])
    designer.destroy
    session.clear # Clear the session to log out the designer after account deletion
    # Success response: Render a confirmation message as JSON
    { message: 'Designer account deleted successfully.' }.to_json
  end

  # Route to create a project proposal for the current designer
  post '/designers/:id/project_proposals' do
    designer = Designer.find(params[:id])
    project_proposal = designer.project_proposals.build(title: params[:title], description: params[:description])
    if project_proposal.save
      # Success response: Render the created project proposal as JSON
      project_proposal.to_json
    else
      # Error response: Render the error message as JSON
      { error: project_proposal.errors.full_messages }.to_json
    end
  end

  # Route to view a specific project proposal
  get '/project_proposals/:id' do
    project_proposal = ProjectProposal.find(params[:id])
    # Success response: Render the project proposal details as JSON
    project_proposal.to_json
  end

  # Route to edit a specific project proposal
  patch '/project_proposals/:id' do
    project_proposal = ProjectProposal.find(params[:id])
    if project_proposal.update(title: params[:title], description: params[:description])
      # Success response: Render the updated project proposal as JSON
      project_proposal.to_json
    else
      # Error response: Render the error message as JSON
      { error: project_proposal.errors.full_messages }.to_json
    end
  end

  # Route to delete a specific project proposal
  delete '/project_proposals/:id' do
    project_proposal = ProjectProposal.find(params[:id])
    project_proposal.destroy
    # Success response: Render a confirmation message as JSON
    { message: 'Project proposal deleted successfully.' }.to_json
  end

  # Route to create a note for a specific project proposal
  post '/project_proposals/:id/notes' do
    project_proposal = ProjectProposal.find(params[:id])
    note = project_proposal.notes.build(author: params[:author], message: params[:message])
    if note.save
      # Success response: Render the created note as JSON
      note.to_json
    else
      # Error response: Render the error message as JSON
      { error: note.errors.full_messages }.to_json
    end
  end

  # Route to view a specific note for a project proposal
  get '/project_proposals/:project_proposal_id/notes/:note_id' do
    project_proposal = ProjectProposal.find(params[:project_proposal_id])
    note = project_proposal.notes.find(params[:note_id])
    # Success response: Render the note details as JSON
    note.to_json
  end

  # Route to edit a specific note for a project proposal
  patch '/project_proposals/:project_proposal_id/notes/:note_id' do
    project_proposal = ProjectProposal.find(params[:project_proposal_id])
    note = project_proposal.notes.find(params[:note_id])
    if note.update(author: params[:author], message: params[:message])
      # Success response: Render the updated note as JSON
      note.to_json
    else
      # Error response: Render the error message as JSON
      { error: note.errors.full_messages }.to_json
    end
  end

  # Route to delete a specific note for a project proposal
  delete '/project_proposals/:project_proposal_id/notes/:note_id' do
    project_proposal = ProjectProposal.find(params[:project_proposal_id])
    note = project_proposal.notes.find(params[:note_id])
    note.destroy
    # Success response: Render a confirmation message as JSON
    { message: 'Note deleted successfully.' }.to_json
  end

  # Error handling route for handling 404 (not found) errors
  not_found do
    # Return a JSON response for 404 error
    status 404
    { error: 'Not Found' }.to_json
  end

  # Error handling route for handling 500 (internal server) errors
  error 500 do
    # Return a JSON response for 500 error
    status 500
    { error: 'Internal Server Error' }.to_json
  end

  # Directory where uploaded files will be stored (using :file storage)
  CarrierWave.configure do |config|
    config.root = File.join(__dir__, 'public')
  end

  # Route to handle avatar upload
  post '/designers/:id/avatar' do
    designer = Designer.find(params[:id])
    designer.avatar = params[:avatar] # params[:avatar] should be the file uploaded in the request
    designer.save
    # Return success response or redirect to the designer's profile page
    { message: 'Avatar uploaded successfully.' }.to_json
  end

  # Route to retrieve the avatar URL for a designer
  get '/designers/:id/avatar' do
    designer = Designer.find(params[:id])
    # Return the avatar URL as JSON
    { avatar_url: designer.avatar.url }.to_json
  end

  get '/' do
    { message: 'Good luck with your project!' }.to_json
  end
end
