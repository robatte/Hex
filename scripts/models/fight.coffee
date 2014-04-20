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
    target = group[Math.floor(Math.random() * group.length)]

    @attackUnit(unit, target)

  attackUnit: (unit, target) ->
    attack_score = unit.attack + Math.floor(Math.random() * 20 - 10)
    target.currentHealth -= unit.damage if attack_score > target.defense

  removeDeadUnits: (units) ->
    units = units.filter (unit) -> unit.currentHealth > 0