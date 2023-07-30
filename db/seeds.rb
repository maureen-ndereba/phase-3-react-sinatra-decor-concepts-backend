puts "🌱 Seeding spices..."
require 'json'

# Seed data for designers
designers_data = [
    {
      name: 'Lakisha Njoki',
      email: 'lakisha@example.com',
      password: 'password123',
      status: 'active'
    },
    {
      name: 'Samuel Owiro',
      email: 'samuel@example.com',
      password: 'password1011',
      status: 'active'
    },
    {
      name: 'Jeffrey Fauzia',
      email: 'jeffrey@example.com',
      password: 'password1213',
      status: 'active'
    }
  ]

# Convert designers_data to JSON and store it as a string
designers_json = JSON.generate(designers_data)
puts designers_json

designers_data.each do |designer_attributes|
  designer = Designer.new(designer_attributes)
  designer.save
end

# Seed data for project proposals
project_proposals_data = [
    {
      designer_id: 1,
      title: 'The Blue House',
      description: 'A beautiful blue-themed house.',
      time_estimate: '24 days',
      material_list: [
        'Blue Paint (4 ltrs)',
        'White Paint (4 ltrs)',
        'Paint Primer (10 ltrs)',
        'Sandpaper (15 mtrs)',
        'Paint Brushes (5 pcs)',
        'Roller Brushes (3 pcs)',
        'Drop Cloth (2 pcs)'
      ]
    },
    {
      designer_id: 1,
      title: 'The Pink Container Project',
      description: 'A unique project using pink shipping containers.',
      time_estimate: '30 days',
      material_list: [
        'Pink Paint (5 ltrs)',
        'Shipping Containers (3 units)',
        'Steel Beams (10 pcs)',
        'Glass Windows (20 pcs)',
        'Insulation Foam (5 sheets)',
        'Metal Screws (100 pcs)',
        'Door Handles (10 pcs)'
      ]
    },
    {
      designer_id: 2,
      title: 'Black on Black House',
      description: 'A modern house with a black color scheme.',
      time_estimate: '28 days',
      material_list: [
        'Black Paint (6 ltrs)',
        'Gray Paint (2 ltrs)',
        'Concrete Blocks (200 pcs)',
        'Glass Railing (30 mtrs)',
        'Floor Tiles (50 sqm)',
        'LED Light Fixtures (15 pcs)',
        'Stainless Steel Sink (1 pc)'
      ]
    },
    {
      designer_id: 3,
      title: 'Boat House',
      description: 'A house inspired by boats and waterfront living.',
      time_estimate: '35 days',
      material_list: [
        'Wooden Planks (100 pcs)',
        'Nautical Rope (50 mtrs)',
        'Anchor (1 pc)',
        'Porthole Windows (10 pcs)',
        'Marine Varnish (5 ltrs)',
        'Boat Cleats (10 pcs)',
        'Captain\'s Wheel (1 pc)'
      ]
    },
    {
      designer_id: 3,
      title: 'Boat House',
      description: 'A house inspired by boats and waterfront living.',
      time_estimate: '35 days',
      material_list: [
        'Wooden Planks (100 pcs)',
        'Nautical Rope (50 mtrs)',
        'Anchor (1 pc)',
        'Porthole Windows (10 pcs)',
        'Marine Varnish (5 ltrs)',
        'Boat Cleats (10 pcs)',
        'Captain\'s Wheel (1 pc)'
      ]
    }
  ]


# Convert project_proposals_data to JSON and store it as a string
project_proposals_json = JSON.generate(project_proposals_data)
puts project_proposals_json

# Seed project proposals
project_proposals_data.each do |proposal_data|
  designer_id = proposal_data[:designer_id]
  proposal_data.delete(:designer_id)

  designer = Designer.find_by(id: designer_id)
  next unless designer

  proposal = designer.project_proposals.build(proposal_data)
  proposal.save
end

# Seed data for notes
notes_data = [
    {
      project_proposal_id: 1,
      message: 'I love the concept of using shipping containers!',
      designer_id: 2
    },
    {
      project_proposal_id: 2,
      message: 'The pink color really stands out!',
      designer_id: 3
    },
    {
      project_proposal_id: 3,
      message: 'The black-on-black design is so elegant!',
      designer_id: 1
    },
    {
      project_proposal_id: 4,
      message: 'I like the large windows for natural light.',
      designer_id: 1
    },
    {
      project_proposal_id: 4,
      message: 'The waterfront location is perfect for this design.',
      designer_id: 3
    },
    {
      project_proposal_id: 3,
      message: 'The use of space is well-planned.',
      designer_id: 2
    },
    {
      project_proposal_id: 1,
      message: 'I would suggest adding more greenery.',
      designer_id: 1
    }
  ]

# Convert notes_data to JSON and store it as a string
notes_json = JSON.generate(notes_data)
puts notes_json

# Seed notes
notes_data.each do |note_data|
  project_proposal_id = note_data.delete(:project_proposal_id)
  note = ProjectProposal.find(project_proposal_id).notes.build(note_data)
  note.save
end

puts "✅ Done seeding!"
