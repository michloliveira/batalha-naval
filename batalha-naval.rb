require "ruby2d"
require_relative "./grid.rb"

set background: Image.new("./images/fundo.png")
set width: 1155, height: 600

orientacaoNavio = true #true significa que o jogador quer colocar o navio na Horizontal
tabuleiro = Grid.new
start = false # var. para saber se alguma tecla já foi pressionada
navios = [6, 4, 3, 3, 1]
i = 0

on :mouse_down do |event|
  square = tabuleiro.contains(event.x, event.y) #verifica se eu cliquei em um quadrado
  if square # só irá executar se eu estou clicando em um quadrado
    if !start
      if i <= 4
        i = i + 1 if tabuleiro.mapShip(tabuleiro.getPosition(event.x, event.y), navios[i]) # o segundo parâmetro é o tamanho do barco: adicionar verificação se o tamanho existe p/ não dar erro
        tabuleiro.message.text = "Click para iniciar o jogo" if i == 5
      else
        start = true
        tabuleiro.message.text = "ACHE OS BARCOS"
        tabuleiro.message2.remove
        tabuleiro.messageOrientacaoNavio.remove
        tabuleiro.messageMudarOrientacao.remove
        tabuleiro.hideShips
      end
    else
      if tabuleiro.containsShip?(tabuleiro.getPosition(event.x, event.y))
        # juntar essas duas funções em uma só: jogada certa
        #tabuleiro.contains(event.x, event.y)
        tabuleiro.revealShip(tabuleiro.getPosition(event.x, event.y))
        #verificar se alguém ganhou
      else
        tabuleiro.naoExisteBarco(tabuleiro.getPosition(event.x, event.y))
        #tabuleiro.contains(event.x, event.y) #tem que substituir por uma função de colorir
        #se não contem barco , pinta de vermelho e passa a vez para o outro
      end
    end
  end
end

# parte para quando o jogador clicar em Espaço, ele inserir o navio na Vertical e vice-versa
 on :key_down do |event|
   if event.key == 'space' && orientacaoNavio == true
     orientacaoNavio = false
     tabuleiro.messageOrientacaoNavio.text = "O barco será inserido na Vertical"
   else
     orientacaoNavio = true
     tabuleiro.messageOrientacaoNavio.text = "O barco será inserido na Horizontal"

   end


end

show
