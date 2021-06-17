require "ruby2d"
require_relative "./grid.rb"

set background: "navy"
set width: 1155, height: 600

tabuleiro = Grid.new
pressed = false # var. para saber se alguma tecla já foi pressionada

on :mouse_down do |event|
  if !pressed
    tabuleiro.mapShip(tabuleiro.getPosition(event.x, event.y))
  else
    if tabuleiro.containsShip?(tabuleiro.getPosition(event.x, event.y))
      # juntar essas duas funções em uma só: jogada certa
      tabuleiro.contains(event.x, event.y)
      tabuleiro.revealShip(tabuleiro.getPosition(event.x, event.y))
      #verificar se alguém ganhou
    end
  end
end

# parte de teste: quando apertar alguma tecla, começa a parte de adivinhar as posições
on :key_down do |event|
  pressed = true
  tabuleiro.message.text = "ACHE OS BARCOS"
  tabuleiro.message2.remove
  tabuleiro.hideShips
end

show
