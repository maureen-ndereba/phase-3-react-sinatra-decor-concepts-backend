puts "🌱 Seeding spices..."
# Seed data for designers
designer1 = Designer.create(name: 'Lakisha Njoki', email: 'lakisha@example.com', password: 'password123')
designer2 = Designer.create(name: 'Monique Atieno', email: 'monique@example.com', password: 'password456')
designer3 = Designer.create(name: 'Luna Nandi', email: 'luna@example.com', password: 'password789')
designer4 = Designer.create(name: 'Samuel Owiro', email: 'samuel@example.com', password: 'password1011')
designer5 = Designer.create(name: 'Jeffrey Fauzia', email: 'jeffrey@example.com', password: 'password1213')

# Seed data for project proposals
project_proposal1 = designer1.project_proposals.create(
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
  )
  
  project_proposal2 = designer1.project_proposals.create(
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
  )
  
  project_proposal3 = designer2.project_proposals.create(
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
  )
  
  project_proposal4 = designer3.project_proposals.create(
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
  )
  
  project_proposal5 = designer4.project_proposals.create(
    title: 'Modern Minimalist Apartment',
    description: 'An apartment with a minimalistic design.',
    time_estimate: '20 days',
    material_list: [
      'Neutral Paint (3 ltrs)',
      'Marble Flooring (50 sqm)',
      'Minimalist Furniture Set (1 set)',
      'Wall Art (5 pcs)',
      'Floor Lamps (2 pcs)',
      'Area Rugs (3 pcs)',
      'Curtains (10 pcs)'
    ]
  )
  
  project_proposal6 = designer5.project_proposals.create(
    title: 'Garden Retreat',
    description: 'A cozy garden retreat with a rustic charm.',
    time_estimate: '25 days',
    material_list: [
      'Wooden Pergola (1 pc)',
      'Outdoor Seating Set (1 set)',
      'Flower Pots (10 pcs)',
      'Garden Lighting (20 pcs)',
      'Garden Statues (5 pcs)',
      'Fountain (1 pc)',
      'Garden Hose (1 pc)'
    ]
  )
  

# Seed data for notes
note1 = project_proposal2.notes.create(author: designer3.name, message: 'I love the concept of using shipping containers!')
note2 = project_proposal2.notes.create(author: designer4.name, message: 'The pink color really stands out!')
note3 = project_proposal3.notes.create(author: designer1.name, message: 'The black-on-black design is so elegant!')
note4 = project_proposal3.notes.create(author: designer5.name, message: 'Great use of contrasting materials.')
note5 = project_proposal4.notes.create(author: designer2.name, message: 'The boat-themed design is very creative.')
note6 = project_proposal4.notes.create(author: designer1.name, message: 'I like the large windows for natural light.')
note7 = project_proposal4.notes.create(author: designer5.name, message: 'The waterfront location is perfect for this design.')
note8 = project_proposal5.notes.create(author: designer2.name, message: 'Clean lines and simplicity - love it!')
note9 = project_proposal5.notes.create(author: designer4.name, message: 'The use of space is well-planned.')
note10 = project_proposal6.notes.create(author: designer3.name, message: 'The garden adds a serene touch to the design.')
note11 = project_proposal6.notes.create(author: designer1.name, message: 'I would suggest adding more greenery.')


puts "✅ Done seeding!"
