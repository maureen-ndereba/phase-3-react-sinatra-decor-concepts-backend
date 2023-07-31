
## Configuration
The backend does not require any special configuration. It uses an SQLite database by default for development purposes.

## Database Schema
The backend uses the following database schema:

- `designers`: Represents designers using the platform and stores their name, email, password digest, status, and avatar.
- `project_proposals`: Stores project proposals created by designers, including the title, description, and the corresponding designer_id.
- `notes`: Represents notes added to project proposals and is associated with designers and project proposals through foreign keys.

## API Documentation
The backend provides the following API endpoints:

- POST `/designers`: Create a new designer account.
Request Body: { "name": "John Doe", "email": "john.doe@example.com", "password": "password123" }

- POST `/login`: Authenticate and log in a designer.
Request Body: { "email": "john.doe@example.com", "password": "password123" }

- GET `/logout`: Log out the current logged-in designer.

- GET `/designers`: View the total number of designers registered on the platform.

- GET `/designers/:id`: View the profile of a specific designer by their ID.

- PATCH `/designers/:id`: Update the profile of the current designer.

- DELETE `/designers/:id`: Delete the account of the current designer.

- POST `/designers/:id/project_proposals`: Create a new project proposal for the current designer.
Request Body: { "title": "Living Room Redesign", "description": "Revamp the living room with a modern touch." }

- GET `/project_proposals/:id`: View the details of a specific project proposal by its ID.

- PATCH `/project_proposals/:id`: Update the details of a specific project proposal.

- DELETE `/project_proposals/:id`: Delete a specific project proposal.

- POST `/project_proposals/:id/notes`: Add a new note to a specific project proposal.
Request Body: { "message": "Remember to consider the client's color preferences." }

- GET `/project_proposals/:project_proposal_id/notes`: View all notes for a specific project proposal.

- GET `/project_proposals/:project_proposal_id/notes/:note_id`: View a specific note for a project proposal.

- PATCH `/project_proposals/:project_proposal_id/notes/:note_id`: Update a specific note for a project proposal.

- DELETE `/project_proposals/:project_proposal_id/notes/:note_id`: Delete a specific note for a project proposal.

## Authentication
The backend uses session-based authentication to manage user login state. When a designer successfully logs in or registers, a session is created, and the designer_id is stored. Subsequent requests can then check the session to determine if a designer is logged in.

## Deployment
To deploy the backend to a production environment, follow these steps:
1. Set up a server with Ruby and a compatible database (e.g., SQLite).
2. Configure environment variables for database connection and session secret.
3. Deploy the backend using a server host or cloud platform (e.g., Heroku, AWS, or DigitalOcean).

## Error Handling
The backend includes error handling for various scenarios, such as invalid routes (404) and internal server errors (500). Error responses are rendered as JSON objects containing error messages.

## Testing
Currently, the backend does not include automated tests. However, thorough testing is recommended to ensure the reliability and stability of the application.

## Technologies Used
- Sinatra: A lightweight web application framework for Ruby.
- ActiveRecord: A Ruby ORM for database management.
- CarrierWave: Used for file uploads and avatar handling.

## Contribution Guidelines
Contributions to this project are welcome! To contribute, please follow the standard Git workflow:
1. Fork the repository.
2. Create a new branch for your changes.
3. Make your changes and commit them with descriptive messages.
4. Push the changes to your forked repository.
5. Submit a pull request to the main repository.

## Contact Information
If you have any questions or need support with the backend, feel free to contact the project maintainers:
- Name: Maureen Ngugi 
- Email: maureen.ngugi@student.moringaschool.com



