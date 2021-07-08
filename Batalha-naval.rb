require "ruby2d"
require_relative "./Tabuleiro.rb"

set background: Image.new("./images/back.jpeg")
set width: 1155, height: 700
set title: "BATALHA NAVAL"

@music = Music.new("./audio/batalha.mp3")
@music.loop = true
@music.play
@music.volume = 25
@orientacaoNavio = 0 #true significa que o jogador quer colocar o navio na Horizontal
@tabuleiro = Tabuleiro.new(0, "jogador", 250,25)
@start = false # var. para saber se alguma tecla já foi pressionada
@restart = false
@vezDoComputador = false
navios = [6, 4, 3, 3, 1]
@i = 0
@perdedor = Image.new("./images/perdeu.png",width: 200, height: 200, x:760, y:200, z:-20)
@marcador = Image.new("./images/alvo.png", width: 49, height:49, opacity: 0)
previsualizacao = Image.new("./images/porta_avioes.png", width: 300, x: 600, y: 300, rotate: 0)
@botao = Rectangle.new(x: 80, y: 285, z: 20, width: 400, height: 60, color: 'green', opacity: 0)
@ganhador = Image.new("./images/medalha.png", width: 200, height: 200, x: 180, y: 200, z: 40, opacity: 0)
@mensagemJoganovamente = Text.new("Clique  para jogar de novo", x: 55, y: 430, z: 100, size: 30, color: "white",opacity: 0)
@message = Text.new("ESCOLHA AS POSIÇÕES PARA OS BARCOS", size: 25, x: 520)
@menssagemOrientacaoNavio = Text.new("O barco será inserido na Horizontal", size: 20, x: 640, y: 120)
@menssagemMudarOrientacao = Text.new("Clique em Espaço para mudar a orientação", size: 20, x: 615, y: 150)

def mapeamento_aleatorio(intervalo_x, intervalo_y)
  # retorna um valor aleatório para x e y, dados seus intervalos
  # retorna também uma orientação, 0 ou 90
  [rand(intervalo_x), rand(intervalo_y), [0, 90].shuffle.first]
end

on :mouse_down do |event|
  if @restart == false
    @start == true ? square = @computador.contains(event.x, event.y) : square = @tabuleiro.contains(event.x, event.y)
    if square && @vezDoComputador == false # só irá executar se eu estou clicando em um quadrado e se não for a vez do computador
      if !@start
        if @i <= 4
          if @tabuleiro.mapearNavio(@tabuleiro.getPosicao(event.x, event.y), navios[@i], @orientacaoNavio) # o segundo parâmetro é o tamanho do barco /// se o barco foi inserido corretamente, entra
            previsualizacao.remove #remover o navio que estava antes para poder mostrar o navio novo sem que tenha uma imagem sobrepondo outra
            @i = @i + 1 #incremento para o proximo indice do vetor de navios
            previsualizacao = Image.new("./images/navio_de_guerra.png", width: 200, x: 650, y: 300, rotate: @orientacaoNavio) if @i == 1 #se o indice for 1, mostro o navio de guerra
            previsualizacao = Image.new("./images/navio_encouracado.png", width: 150, x: 700, y: 300, rotate: @orientacaoNavio) if @i == 2 or @i == 3 #se o indice for 2 ou 3, mostro o navio encouraçado
            previsualizacao = Image.new("./images/submarino.png", width: 50, x: 750, y: 300, rotate: @orientacaoNavio) if @i == 4 # se o indice for 4, mostro o submarino
            @botao.opacity = 100 and @mensagemInicioJogo = Text.new("Click para iniciar o jogo", x: 90, y: 300, z: 25, size: 30, color: "white") and @menssagemOrientacaoNavio.remove and @menssagemMudarOrientacao.remove and @message.remove if @i == 5 #apagando as mensagens sobre a orietação do navio        end
          end
        else
          @ganhador.opacity = 0
          @mensagemJoganovamente.opacity = 0
          @mensagemInicioJogo.remove
          @botao.remove
          @computador = Tabuleiro.new(600, "pc", 850,625)  #cria um novo @tabuleiro para computador

          navios.each do |navio|
            loop do
              mapeamento = mapeamento_aleatorio((621..1119), (101..599))
              i = @computador.getPosicao(mapeamento[0], mapeamento[1])
              break if @computador.mapearNavio(i, navio, mapeamento[2])
            end
          end

          @start = true
          @message.text = "ACHE OS BARCOS"
          @tabuleiro.esconderNavios
          @computador.esconderNavios
          @seta = Image.new("./images/setaa.png", width: 100, height: 100, x: 520, y: 300)
        end
       
      else #o jogo iniciou
        @ganhador.opacity = 0
        @mensagemJoganovamente.opacity = 0
        if !@tabuleiro.posicaoJaJogada?(@computador.getPosicao(event.x, event.y))
          if @computador.temNavio?(@computador.getPosicao(event.x, event.y))
            @computador.revelarNavio(@computador.getPosicao(event.x, event.y))
            #verificar se alguém ganhou
            if @computador.ganhou?
              @music.stop
              @perdedor.z = 20
              @ganhador.opacity = 100

              @mensagemJoganovamente.opacity = 100
              vitoria = Sound.new("./audio/ganhou.wav")
              vitoria.play
              @restart = true
            end
          else
            @computador.naoExisteNavio(@computador.getPosicao(event.x, event.y)) #pinta de vermelho
            #vez do computador
            @vezDoComputador = true
          end
          @tabuleiro.definirPosicaoComoJogada(@computador.getPosicao(event.x, event.y))
        end
      end
    end
  else #restart
    @perdedor.z = -10
    @music.play
    @tabuleiro = Tabuleiro.new(0, "jogador", 250,25)
    @message = Text.new("ESCOLHA AS POSIÇÕES PARA OS BARCOS", size: 25, x: 520)
    @menssagemOrientacaoNavio = Text.new("O barco será inserido na Horizontal", size: 20, x: 640, y: 120)
    @menssagemMudarOrientacao = Text.new("Clique em Espaço para mudar a orientação", size: 20, x: 615, y: 150)

    previsualizacao = Image.new("./images/porta_avioes.png", width: 300, x: 600, y: 300, rotate: @orientacaoNavio)
    @botao = Rectangle.new(x: 80, y: 285, z: 20, width: 400, height: 60, color: "green", opacity: 0)
    @computador.reiniciar
    @mensagemJoganovamente.opacity = 0
    @ganhador.opacity = 0
    @seta.remove
    @i = 0
    @start = false
    @restart = false
  end
end

# parte para quando o jogador clicar em Espaço, ele inserir o navio na Vertical e vice-versa
on :key_down do |event|
  if event.key == "space" && @orientacaoNavio == 0
    @orientacaoNavio = 90
    previsualizacao.rotate = 90
    @menssagemOrientacaoNavio.text = "O barco será inserido na Vertical"
  else
    @orientacaoNavio = 0
    previsualizacao.rotate = 0
    @menssagemOrientacaoNavio.text = "O barco será inserido na Horizontal"
  end
end

clock = 1
update do
  if @vezDoComputador
    @seta.rotate = 180
    if clock % 120 == 0 # espera 2 segundos antes de jogar
      mapeamento = 0 # apenas para definir a variável, porque não daria pra acessar depois se a definição ficasse apenas no loop
      #vai entrar nesse loop enquanto não sair uma posição que ainda não foi jogada
      loop do
        mapeamento = mapeamento_aleatorio((21..519), (101..599)) # intervalo do jogador já definido
        break if !@computador.posicaoJaJogada?(@tabuleiro.getPosicao(mapeamento[0], mapeamento[1])) || !@computador.haPosicoesNaoJogadas()
      end
      @computador.definirPosicaoComoJogada(@tabuleiro.getPosicao(mapeamento[0], mapeamento[1])) # adiciona a posição jogada no array de posições jogadas
      if @tabuleiro.temNavio?(@tabuleiro.getPosicao(mapeamento[0], mapeamento[1]))
        @tabuleiro.revelarNavio(@tabuleiro.getPosicao(mapeamento[0], mapeamento[1]))
        if @tabuleiro.ganhou?
          @perdedor.x = 180
          @perdedor.y = 200
          @perdedor.z = 40
          @music.stop
          @ganhador.opacity = 100
          @ganhador.x = 760
          @ganhador.y = 200   
          @ganhador.z = 20
          @perdeu = Sound.new("./audio/perdeu.wav")
          @perdeu.play
          @ganhador.opacity = 100
          @mensagemJoganovamente.opacity = 100
          @vezDoComputador = false
          @restart = true
        end
      else
        @tabuleiro.naoExisteNavio(@tabuleiro.getPosicao(mapeamento[0], mapeamento[1])) #pinta de vermelho
        @vezDoComputador = false
        @seta.rotate = 0
      end
    end
    clock += 1
  end
end

on :mouse do |event|
  if @start and !@vezDoComputador
    if square = @computador.contains(event.x, event.y)
      @marcador.x = event.x - 20
      @marcador.y = event.y - 20
      @marcador.z = 20
      @marcador.opacity = 100
    else
      @marcador.opacity = 0
    end
  else
    @marcador.opacity=0
  end
end

show
