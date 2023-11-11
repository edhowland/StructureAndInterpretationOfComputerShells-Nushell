# hint2.nu possible replacement for hint?

def hint2 [code: string] {
  let guess = $in
  let bpg_ = ($guess | black pegs $code)
  let wpg_ = ($guess | white pegs $code)
  for c in ($wpg_ | reverse) { $c | stack push }
  $bpg_ | each {|it| if $it != 'B' { stack pop } else { 'B' } }
  #$bpg_ | each {|it| if $it == 'B' { 'B' } else { 'X' } }
}
