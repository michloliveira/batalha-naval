require "ruby2d"
require_relative "./grid.rb"

set background: Image.new("./images/fundo.png")
set width: 1155, height: 600
set title: "BATALHA NAVAL"

orientacaoNavio = 0 #true significa que o jogador quer colocar o navio na Horizontal
tabuleiro = Grid.new
start = false # var. para saber se alguma tecla já foi pressionada
navios = [6, 4, 3, 3, 1]
i = 0
previsualizacao = Image.new("./images/porta_avioes.png", width: 300, x: 600, y: 300, rotate: 0)

on :mouse_down do |event|
  square = tabuleiro.contains(event.x, event.y) #verifica se eu cliquei em um quadrado
  if square # só irá executar se eu estou clicando em um quadrado
    if !start
      if i <= 4
        if tabuleiro.mapearNavio(tabuleiro.getPosicao(event.x, event.y), navios[i], orientacaoNavio) # o segundo parâmetro é o tamanho do barco /// se o barco foi inserido corretamente, entra
          previsualizacao.remove #remover o navio que estava antes para poder mostrar o navio novo sem que tenha uma imagem sobrepondo outra
          i = i + 1 #incremento para o proximo indice do vetor de navios
          previsualizacao = Image.new("./images/navio_de_guerra.png", width: 200, x: 650, y: 300, rotate: orientacaoNavio) if i == 1 #se o indice for 1, mostro o navio de guerra
          previsualizacao = Image.new("./images/navio_encouracado.png", width: 150, x: 700, y: 300, rotate: orientacaoNavio) if i == 2 or i == 3 #se o indice for 2 ou 3, mostro o navio encouraçado
          previsualizacao = Image.new("./images/submarino.png", width: 50, x: 750, y: 300, rotate: orientacaoNavio) if i == 4 # se o indice for 4, mostro o submarino
          tabuleiro.message.text = "Click para iniciar o jogo" and tabuleiro.messageOrientacaoNavio.remove and tabuleiro.messageMudarOrientacao.remove if i == 5 #apagando as mensagens sobre a orietação do navio
        end
      else
        start = true
        tabuleiro.message.text = "ACHE OS BARCOS"
        tabuleiro.esconderNavios
      end
    else
      if tabuleiro.temNavio?(tabuleiro.getPosicao(event.x, event.y))
        # juntar essas duas funções em uma só: jogada certa
        #tabuleiro.contains(event.x, event.y)
        tabuleiro.revelarNavio(tabuleiro.getPosicao(event.x, event.y))
        #verificar se alguém ganhou
        if tabuleiro.ganhou?
          tabuleiro.message.text = "TODOS OS BARCOS FORAM ENCONTRADOS"
        end
      else
        tabuleiro.naoExisteNavio(tabuleiro.getPosicao(event.x, event.y))
        #tabuleiro.contains(event.x, event.y) #tem que substituir por uma função de colorir
        #se não contem barco , pinta de vermelho e passa a vez para o outro
      end
    end
  end
end

# parte para quando o jogador clicar em Espaço, ele inserir o navio na Vertical e vice-versa
on :key_down do |event|
  if event.key == "space" && orientacaoNavio == 0
    orientacaoNavio = 90
    previsualizacao.rotate = 90
    tabuleiro.messageOrientacaoNavio.text = "O barco será inserido na Vertical"
  else
    orientacaoNavio = 0
    previsualizacao.rotate = 0
    tabuleiro.messageOrientacaoNavio.text = "O barco será inserido na Horizontal"
  end
end

show
