# t.nu  used for testing
source init.nu
source player.nu
source analyze.nu
source game.nu
source srfriend.nu

let c = 'rrbb'
let g = 'rbgy'
let code = (make code)



# debugging


# examines its input by converting it to NuON and then editing stdin
def examine [] {
  to nuon | viper -i
}
