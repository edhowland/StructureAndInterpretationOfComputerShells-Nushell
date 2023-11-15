# hint3.nu : third attempt

def hint3 [code: string] {
  let guess = $in
let blist = ($guess | black pegs $code)
  let wlist = ($guess | white pegs $code)

  $blist | enumerate | filter {|it| $it.item == ' ' } | get index | enumerate | reduce -f $blist {|it, acc| $acc | update $it.item ($wlist | get $it.index) } | str join ''

}