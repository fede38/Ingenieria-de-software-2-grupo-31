nombres = [
  'Isidro', 'Carmelo', 'Gerardo',
  'Gustavo', 'Iker', 'Manuel',
  'Antonio', 'Jose',' Maria', 'Juan'
]
apellidos = [
  'Viva', 'Santana', 'Famadas', 'Garcia',
  'Toledo', 'Malaguilla', 'Lopez',
  'Fernandez', 'Rodriguez', 'Gonzalez'
]
marcas = [
  'Mitsubishi', 'Fiat', 'Chevrolet',
  'Citroen', 'Audi', 'Volkswagen',
  'Ferrari', 'Lamborghini', 'Ford',
  'Mercedes benz'
]
colores = [
  'Azul', 'Rojo', 'Rosa', 'Amarillo',
  'Verde', 'Naranja', 'Violeta',
  'Blanco', 'Negro', 'Gris'
]
destinos = [
  'La plata', 'Buenos aires', 'Olavarria',
  'Azul', 'Pinamar', 'Rosario', 'Salta',
  'Bariloche', 'Resistencia', 'Trelew',
  'Posadas', 'Bahia blanca', 'Las flores',
  'Rio cuarto', 'Puerto madryn'
]

dir = 'imagenesSeed'
archivos = Dir.foreach(dir) \
.map { |x| File.expand_path("#{dir}/#{x}") } \
.select { |x| File.file?(x) }

10.times do |u|
  user = User.new(
    nombre: nombres[u],
    apellido: apellidos[u],
    email: apellidos[u].downcase+'@fakemail.com',
    fecha_nacimiento: "199"+u.to_s+"-01-01",
    password: '123456',
    password_confirmation: '123456',
    avatar: File.new(archivos[u], 'r')
  )
  user.skip_confirmation!
  user.save!
  user.account = Account.create
end

10.times do |a|
  auto = Vehicle.new(
    patente: [*('a'..'z'),*('0'..'9')].shuffle[0,6].join,
    modelo: 1900+a*10,
    marca: marcas[a],
    sub_marca: rand(1..1000),
    cantidad_asientos: rand(1..10),
    color: colores[a],
    tipo: 'Auto',
  )
  auto.save!
end

User.all.each do |user|
  10.times do |valor|
    if rand(1..10) < 3
      autoRandom = Vehicle.find(rand(1..10))
      unless user.vehicles.exists?(:id => autoRandom.id)
        user.vehicles << autoRandom
      end
    end
  end
end

15.times do |v|
  begin
    $user = User.find(rand(1..10))
  end until !$user.vehicles.empty?
  viaje = Trip.new(
    descripcion: "Esta es la descripcion numero: "+ v.to_s + ".",
    fecha_inicio: "2018-"+rand(7..12).to_s+"-"+rand(1..31).to_s,
    hora_inicio: rand(00..23).to_s+":"+rand(00..59).to_s,
    costo: rand(1000.0...5000.0),
    destino: destinos[v],
    activo: true,
    user_id: $user.id,
    vehicle_id: $user.vehicles.all.sample.id,
  )
  viaje.save!
end

15.times do |i|
  viaje = Trip.find(i+1)
  User.all.each do |usuario|
    if rand(1..10) <3 && viaje.piloto != usuario
      viaje.postulantes << usuario
    end
  end
end
