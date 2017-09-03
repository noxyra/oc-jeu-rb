class Personne
  attr_accessor :nom, :points_de_vie, :en_vie

  def initialize(nom)
    @nom = nom
    @points_de_vie = 100
    @en_vie = true
  end

  def info
    if en_vie == true
      return "#{nom} (#{points_de_vie}/100 pv)"
    else
      return "#{nom} (vaincu)"
    end
  end

  def attaque(personne)
    personne.subit_attaque(self.degats)
    puts "Vous avez attaqué #{personne.nom}"

  end

  def subit_attaque(degats_recus)
    self.points_de_vie = points_de_vie - degats_recus

    if points_de_vie <= 0
      self.en_vie = false
      puts "#{nom} est mort sur le coup !"
    else
      puts "#{nom} s'est fait later, des dents ont volées !"
    end
  end
end

class Joueur < Personne
  attr_accessor :degats_bonus

  def initialize(nom)
    # Par défaut le joueur n'a pas de dégats bonus
    @degats_bonus = 0

    # Appelle le "initialize" de la classe mère (Personne)
    super(nom)
  end

  def degats
    puts "Oula, le coup est partit plus vite que la pensée !"
    total = 5 + degats_bonus
    return total
  end

  def soin
    # J'ai ajouté le fait de pas pouvoir se soigner plus que sa vie max.

    ptsSoin = 30
    self.points_de_vie += ptsSoin

    if self.points_de_vie > 100
      self.points_de_vie = 100
    end

    puts "Vous vous êtes soignés !"
  end

  def ameliorer_degats
    ptsBonus = 2
    self.degats_bonus += ptsBonus
    puts "Vous améliorez votre attaque de #{ptsBonus} points !"
  end
end

class Ennemi < Personne
  def degats
    return 3
  end
end

class Jeu
  def self.actions_possibles(monde)
    puts "ACTIONS POSSIBLES :"

    puts "0 - Se soigner"
    puts "1 - Améliorer son attaque"

    # On commence à 2 car 0 et 1 sont réservés pour les actions
    # de soin et d'amélioration d'attaque
    i = 2
    monde.ennemis.each do |ennemi|
      puts "#{i} - Attaquer #{ennemi.info}"
      i = i + 1
    end
    puts "99 - Quitter"
  end

  def self.est_fini(joueur, monde)
    if joueur.en_vie == false || monde.ennemis_en_vie.size == 0
      return true
    end
  end
end

class Monde
  attr_accessor :ennemis

  def ennemis_en_vie
    result = []

    ennemis.each do |enemi|
      if enemi.en_vie == true
        result << enemi
      end
    end

      return result
  end
end

##############

# Initialisation du monde
monde = Monde.new

# Ajout des ennemis
monde.ennemis = [
  Ennemi.new("Balrog"),
  Ennemi.new("Goblin"),
  Ennemi.new("Squelette")
]

# Initialisation du joueur
joueur = Joueur.new("Jean-Michel Paladin")

# Message d'introduction. \n signifie "retour à la ligne"
puts "\n\nAinsi débutent les aventures de #{joueur.nom}\n\n"

# Boucle de jeu principale
100.times do |tour|
  puts "\n------------------ Tour numéro #{tour} ------------------"

  # Affiche les différentes actions possibles
  Jeu.actions_possibles(monde)

  puts "\nQUELLE ACTION FAIRE ?"
  # On range dans la variable "choix" ce que l'utilisateur renseigne
  choix = gets.chomp.to_i

  # En fonction du choix on appelle différentes méthodes sur le joueur
  if choix == 0
    joueur.soin
  elsif choix == 1
    joueur.ameliorer_degats
  elsif choix == 99
    # On quitte la boucle de jeu si on a choisi
    # 99 qui veut dire "quitter"
    break
  else
    # Choix - 2 car nous avons commencé à compter à partir de 2
    # car les choix 0 et 1 étaient réservés pour le soin et
    # l'amélioration d'attaque
    ennemi_a_attaquer = monde.ennemis[choix - 2]
    joueur.attaque(ennemi_a_attaquer)
  end

  puts "\nLES ENNEMIS RIPOSTENT !"
  # Pour tous les ennemis en vie ...
  monde.ennemis_en_vie.each do |ennemi|
    # ... le héro subit une attaque.
    ennemi.attaque(joueur)
  end

  puts "\nEtat du héro: #{joueur.info}\n"

  # Si le jeu est fini, on interompt la boucle
  break if Jeu.est_fini(joueur, monde)
end

puts "\nGame Over!\n"

puts "Etat du joueur en fin de partie : \n    #{joueur.info}"

puts "Etat des ennemis en fin de partie :"

monde.ennemis.each do |ennemi|
  puts ennemi.info
end

puts "\n\n====="

if joueur.en_vie
  puts "Vous avez gagné !"
else
  puts "Vous avez perdu !"
end
