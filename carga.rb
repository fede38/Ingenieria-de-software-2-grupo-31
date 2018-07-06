viaje1 = Trip.find(1)
viaje2 = Trip.find(2)
user = User.find(1)
if viaje1.piloto != User.find(1)
  viaje1.postulantes << User.find(1)
end
if viaje2.piloto != User.find(1)
  viaje2.postulantes << User.find(1)
end
Embarkment.find_by(user: 1, trip: 1).update_attribute(:estado, 'a')
Embarkment.find_by(user: 1, trip: 2).update_attribute(:estado, 'a')
viaje1.increment!(:cantidad_asientos_ocupados, 1)
viaje2.increment!(:cantidad_asientos_ocupados, 1)

viaje1.update_attribute(:fecha_inicio, ARGV[0])
viaje2.update_attribute(:fecha_inicio, ARGV[0])
viaje1.update_attribute(:hora_inicio, ARGV[1])
viaje2.update_attribute(:hora_inicio, ARGV[1])

User.find(1).account.update_attribute(:saldo, 5000)
