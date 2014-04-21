class Fight

  constructor: (@attacker_amry, @defender_army) ->
    @units = []
    @units[0] = @attacker_amry.movableUnits()
    @units[1] = @defender_army.units

    @fight()

    @attacker_amry.units = @units[0].concat @attacker_amry.notMovableUnits()
    @defender_army.units = @units[1]

  fight: ->

    # get array of all units in random order
    @all = []
    for i in [0..1]
      @all.push {army_id: i, unit} for unit in  @units[i]

    @all = Helper.shuffle_array @all

    while @units[0].length > 0 and @units[1].length > 0
      for entry in @all
        other_army_id = (entry.army_id + 1) % 2
        @attackGroup(entry.unit, @units[other_army_id])
        @units[other_army_id] = @removeDeadUnits(@units[other_army_id])
        break if @units[other_army_id].length == 0

  attackGroup: (unit, group) ->

    # select target unit
    tactic = Math.floor(Math.random() * 4)
    if tactic < 3
      # select unit with minimum health
      target = group.sort( (x, y) -> x.currentHealth - y.currentHealth )[0]
    else
      # select random unit
      target = group[Math.floor(Math.random() * group.length)]

    @attackUnit(unit, target)

  attackUnit: (unit, target) ->

    # role dice to get score (see http://www.redblobgames.com/articles/probability/damage-rolls.html)
    attack_score = @rollDice(unit.attack_roles, unit.attack_dice) + unit.attack_offset
    attack_score = 0 if attack_score < 0

    # apply armor
    attack_score = Math.round  attack_score * (1 - target.armor)

    # calc new health
    target.currentHealth -= attack_score

  removeDeadUnits: (units) ->
    units = units.filter (unit) -> unit.currentHealth > 0


  rollDice: (n, s) ->
    # thanks to blogarticle http://www.redblobgames.com/articles/probability/damage-rolls.html
    # Sum of N dice each of which goes from 0 to S
    value = 0
    value += Math.floor((s + 1) * Math.random()) for i in [0..n]
    value


  @calcFightStatistic: (unit_type_attacker, unit_type_defender, attacker_count, defender_count) ->

    units_set_attacker = {}
    units_set_attacker[unit_type_attacker] = attacker_count

    units_set_defender = {}
    units_set_defender[unit_type_defender] = defender_count

    attackers = UnitFactory.get().build units_set_attacker, new Player("attacker")
    defenders = UnitFactory.get().build units_set_defender, new Player("defender")

    new Fight attackers, defenders

    winner = if attackers.units.length > 0 then attackers else defenders
    health = winner.units.map( (unit) -> unit.currentHealth ).reduce( (x,y) -> x + y )
    health /= winner.units.length
    alert("attackers: #{attackers.units.length} / defenders: #{defenders.units.length} / mean winner health: #{health}")