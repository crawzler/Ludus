# LUDUS — Estado atual

Este e o checkpoint operacional unico. Substitua as secoes de tarefa/checkpoint conforme o trabalho progride; nao use o diario como substituto deste arquivo.

## Checkpoint

- **Atualizado em:** 2026-10-14 14:50 (-03:00)
- **Marco:** GAME-009 — implementacao do arsenal minimo concluida; aguardando verificacao funcional manual.
- **Estado geral:** versao `0.1.0-pre-alpha`; implementados espada/lanca com alcances e ritmos distintos e troca por Q; validacao visual ainda pendente.
- **Projeto/engine:** `project.godot` declara Godot 4.7. VS Code tem extensao `geequlim.godot-tools`; `.vscode/settings.json` aponta para `e:\Godot_v4.7.2-stable_win64.exe`.
- **Branch:** `main`.
- **Commit da configuracao de agentes/documentacao:** `7fb3c56` — `docs: configure continuity and automatic local commits`.
- **Remoto observado:** `origin` aponta para `https://github.com/crawzler/Ludus.git`; `main` e `origin/main` estao sincronizadas apos o fechamento da GAME-008.
- **Politica de publicacao:** usuario autorizou push automatico ao GitHub apos cada commit de tarefa concluida e validada. Nao enviar alteracoes sem commit nem tarefas incompletas.
- **Git nesta retomada:** `main` em `7d2ae4c`, igual a `origin/main`; ha modificacao local em `project.godot` e arquivos nao rastreados `.vscode/` e `docs/BUGS.md`. Preservar e manter fora de qualquer commit desta tarefa.

## Tarefa concluida anterior

- **ID:** DOC-001
- **Nome:** Criar protocolo de continuidade e recuperacao entre agentes e conversas
- **Status:** CONCLUIDA
- **Responsavel:** LUDUS Coordinator
- **Pedido:** Preparar um sistema de documentacao para todos os agentes retomarem o contexto e continuarem exatamente de onde o processo parou, inclusive apos trocar de agente, chat ou aplicativo.
- **Objetivo:** Manter uma fonte de verdade atual, trilha de mudancas e procedimento de recuperacao que nao dependam do historico de conversa.
- **Escopo:** Criar protocolo, estado, diario e registro de decisoes; incluir GDD no repositorio; instruir agentes e skills a ler/escrever os registros no momento apropriado.
- **Fora do escopo:** Implementar gameplay, instalar plugins, criar commits ou publicar alteracoes.
- **Criterio de conclusao:** documentos criados e coerentes; agentes instruidos para retomar e checkpointar; GDD original copiado sem alteracao; validacao documental concluida.

## Checkpoint da tarefa concluida

- **Ultimo passo concluido:** Criados protocolo, checkpoint, registro de decisoes, diario, copia do GDD e instrucoes de continuidade para agentes, skills e guia.
- **Resultado verificavel:** SHA-256 do GDD original e da copia coincidem: `53315BB77C7F23BE9CFEDCD4CBB0508EE7FD373DD09F74D8BB7C890D9836FBA8`. Todos os agentes e skills relevantes referenciam o protocolo de continuidade.
- **Arquivos de gameplay alterados:** nenhum.
- **Validacoes:** estado Git inspecionado; hash da copia do GDD comparado; revisao dos arquivos e validacao de whitespace concluidas.
- **Bloqueios:** nenhum.
- **Riscos/contexto faltante:** confirmar que o jogo abre no Godot instalado e corrigir o nome ainda padrao em `project.godot` e necessario como uma futura tarefa, nao como parte deste protocolo.
- **Proxima acao exata:** revisar as alteracoes locais com `git status --short --branch`; quando desejar preservar este marco no GitHub, adicionar, commitar e enviar a branch `main`. Depois confirmar no Godot que o projeto abre antes de iniciar o Marco 1.
- **Entrada do diario:** `docs/DIARIO_DE_DESENVOLVIMENTO.md`, DOC-001, 2026-10-14.

## Tarefa concluida anterior

- **ID:** GAME-001
- **Nome:** Criar arena minima e movimentacao do jogador
- **Status:** CONCLUIDA
- **Responsavel:** LUDUS Coordinator, com delimitacao do LUDUS Planner e implementacao do LUDUS Developer
- **Pedido:** iniciar o prototipo depois de confirmar que o projeto abre sem erros; usuario autorizou alterar o codigo e confirmou que a arena retangular em visao de cima, personagem circular, controles WASD e colisao com as bordas estao corretos.
- **Objetivo:** criar o primeiro espaco jogavel do Marco 1.
- **Escopo:** arena temporaria de visao superior, personagem circular, movimento pelo teclado, colisao nas bordas e camera fixa; sem combate ou gestao.
- **Criterio de conclusao:** arena e jogador visiveis, movimento e colisao confirmados pelo usuario; movimento diagonal normalizado por codigo.
- **Arquivos:** `project.godot`, `scenes/arena.tscn`, `scenes/player.tscn`, `scripts/arena.gd`, `scripts/arena.gd.uid`, `scripts/player.gd`, `scripts/player.gd.uid`, este estado, `docs/DIARIO_DE_DESENVOLVIMENTO.md` e `docs/DECISOES.md`.
- **Validacoes:** revisao estatica de cenas/scripts e referencias; `git diff --check` passou; usuario confirmou o comportamento visual e jogavel descrito acima. O executavel Godot nao esta no PATH, portanto nenhum teste automatizado/editor foi executado nesta sessao.
- **Decisao em aberto:** perspectiva isometrica futura e comportamento se camera/mundo girarem permanecem para decisao/teste posterior; a aprovacao desta arena temporaria nao altera essa direcao.
- **Entrada do diario:** GAME-001, 2026-10-14.
- **Proxima acao exata:** GAME-002 concluiu o ataque basico; seguir a ordem do guia com implementacao de inimigo funcional e leitura dos seus ataques, em tarefa separada.

## Tarefa mais recente

- **ID:** GAME-002
- **Nome:** Implementar ataque basico com dano e feedback
- **Status:** CONCLUIDA — validada pelo usuario
- **Responsavel:** LUDUS Coordinator, com delimitacao do LUDUS Planner, implementacao do LUDUS Developer e roteiro do LUDUS Playtester
- **Pedido:** apos ser informado que o proximo incremento recomendado e ataque basico, dano e feedback com alvo de treino parado, o usuario autorizou iniciar.
- **Objetivo:** fazer um ataque basico do jogador acertar um alvo e comunicar visualmente o acerto/dano.
- **Escopo:** ataque de proximidade circular em tecla dedicada, acerta alvo de treino parado, reduz vida e produz feedback visual temporario; sem IA, direcao de mira, defesa, HUD ou gestao.
- **Parametros temporarios do prototipo:** tecla `F`, alcance 48 pixels, 1 de dano por pressionamento, alvo com 3 de vida que desaparece ao zerar; nao aprovados como regras definitivas de arma/combate.
- **Criterio de conclusao:** ataque, dano, feedback e movimento funcionando, confirmado pelo usuario como "Tudo certo".
- **Arquivos:** `project.godot`, `scenes/arena.tscn`, `scripts/player.gd`, `scenes/training_target.tscn`, `scripts/training_target.gd`, `scripts/training_target.gd.uid`, este checkpoint e `docs/DIARIO_DE_DESENVOLVIMENTO.md`.
- **Ultimo passo concluido:** mapeamento `attack` na tecla F; ataque radial de alcance 48 px a partir do centro do jogador, com 1 de dano por pressionamento; alvo parado com 3 de vida, flash de cor e remocao apos o feedback do golpe final; alvo colocado em `(560, 270)`, a 80 px do ponto inicial do jogador.
- **Validacoes:** verificacao estatica, referencias de recursos e `git diff --check` passaram; usuario confirmou o comportamento como correto. O executavel Godot nao esta no PATH para validacao automatizada; validacao funcional humana registrada pelo usuario.
- **Riscos/limitacoes:** tecla, alcance, dano e vida permanecem parametros temporarios; alvo sem colisao fisica e alcance medido entre centros, conforme incremento minimo.
- **Entrada do diario:** GAME-002, 2026-10-14.
- **Proxima acao exata:** iniciar incremento separado para inimigo funcional e leitura dos seus ataques, conforme guia.

## Tarefa concluida mais recente

- **ID:** GAME-003
- **Nome:** Trocar ataque para clique esquerdo e exibir hitbox
- **Status:** CONCLUIDA — validada pelo usuario
- **Responsavel:** LUDUS Coordinator
- **Pedido:** mudar o ataque de F para clique esquerdo e adicionar feedback visual para o hitbox.
- **Objetivo/escopo:** manter logica, dano e alcance de ataque; desenhar temporariamente o raio de alcance apos ataque; nao mexer na configuracao do VS Code.
- **Arquivos:** `project.godot`, `scripts/player.gd`, este estado e diario. `.vscode/settings.json` pertence ao usuario e permaneceu intacto.
- **Validacoes:** Godot 4.7.2 headless importou e inicializou a arena sem erros; usuario confirmou visualmente "Tudo certo"; `git diff --check` passou. Nenhum push.
- **Entrada do diario:** GAME-003, 2026-10-14.

## Tarefa concluida mais recente

- **ID:** GAME-004
- **Nome:** Criar inimigo funcional com ataques legiveis
- **Status:** CONCLUIDA — validada pelo usuario
- **Responsavel:** LUDUS Coordinator
- **Pedido:** seguir apos a validacao do clique/indicador, incluindo um inimigo funcional e ataques que o jogador consiga ler.
- **Objetivo/escopo:** inimigo placeholder persegue, telegrapha ataque circular, executa golpe visual, recupera e pode ser atingido pelo ataque do jogador; sem causar dano nesta etapa.
- **Criterio de conclusao:** usuario confirmou "Perfeito, pode continuar" apos receber instrucoes para validar comportamento; comportamento aceito como correto.
- **Parametros temporarios:** velocidade 90 px/s, alcance 72 px, telegrapho 0,65 s, ataque 0,18 s, recuperacao 1 s, 3 pontos de vida. Nao definem classe ou arma final; DEC-P03 continua aberta.
- **Arquivos:** `scenes/arena.tscn`, `scenes/player.tscn`, `scenes/training_target.tscn`, `scenes/enemy.tscn`, `scripts/player.gd`, `scripts/enemy.gd`, UID do script, este estado e diario. `.vscode/` ficou de fora.
- **Validacoes:** Godot 4.7.2 importou e executou cena inicial headless por 240 frames sem erros; Language Server nao reporta erros nos scripts; `git diff --check` passou; validacao funcional confirmada pelo usuario.
- **Entrada do diario:** GAME-004, 2026-10-14.
- **Proxima acao exata:** iniciar GAME-005, vida e resultados vitoria/derrota, seguindo a ordem do guia.

## Tarefa mais recente

- **ID:** GAME-005
- **Nome:** Adicionar vida e resultados de vitoria/derrota
- **Status:** CONCLUIDA — validada pelo usuario
- **Responsavel:** LUDUS Coordinator, com delimitacao do LUDUS Planner e implementacao do LUDUS Developer
- **Pedido:** adicionar dano efetivo, vida e resultados claros apos validar o inimigo.
- **Objetivo/escopo:** jogador e inimigo com vida; dano de area no fim do telegraph quando dentro de 72 px; HUD minimo; mensagem de VITORIA/DERROTA e bloqueio de combate apos fim.
- **Parametros temporarios:** 3 HP por lado e 1 dano por ataque, nao sao balanceamento final.
- **Arquivos:** `scripts/player.gd`, `scripts/enemy.gd`, `scripts/arena.gd`, `scenes/arena.tscn`, este estado e diario. `.vscode/` permaneceu fora da tarefa.
- **Validacoes:** teste headless focado e smoke test Godot 4.7.2 passaram; usuario respondeu "Perfeito" apos instrucoes de verificacao, registrada como validacao funcional/visual; `git diff --check` passou.
- **Entrada do diario:** GAME-005, 2026-10-14.
- **Proxima acao exata:** avaliar bloqueio como proximo incremento de combate, conforme guia, quando o usuario quiser continuar.

## Tarefa concluida mais recente

- **ID:** GAME-006
- **Nome:** Adicionar bloqueio basico
- **Status:** CONCLUIDA — validada pelo usuario
- **Responsavel:** LUDUS Coordinator
- **Pedido:** usuario pediu "proximo passo" apos GAME-005; o guia lista bloqueio como proxima mecanica de combate.
- **Objetivo:** permitir ao jogador defender-se do golpe telegrafado do inimigo por uma acao clara e testavel.
- **Escopo:** bloqueio mantido na barra de espaco, consultado no instante do impacto do inimigo; anula dano e mostra feedback visual breve; movimento permanece sem penalidade. Sem aparo, esquiva, stamina ou HUD.
- **Parametros temporarios:** barra de espaco, anulacao integral do golpe e movimento sem penalidade, sem aprovacao como balanceamento definitivo.
- **Criterio de conclusao:** bloquear no instante do impacto evita perda de HP e mostra feedback; soltar antes permite dano; movimento, ataque e resultados continuam funcionando.
- **Arquivos:** `project.godot`, `scripts/player.gd`, `scripts/enemy.gd`, este estado e diario. `.vscode/` permanece intocada e fora do commit.
- **Ultimo passo concluido:** usuario confirmou "Tudo certo" apos executar o playtest manual, validando o bloqueio e seu feedback no jogo.
- **Validacoes:** Godot 4.7.2 importou o projeto e executou a arena por 240 frames sem erros; teste focado headless confirmou bloqueio sem dano, dano ao liberar Space, movimento e ataque durante o bloqueio e limpeza no fim da luta; usuario validou manualmente o comportamento; `git diff --check` passou.
- **Riscos/contexto:** Space, negacao integral e movimento sem penalidade continuam parametros provisórios do prototipo, nao balanceamento definitivo.
- **Commit local:** `a806961` — `feat: add basic held block`.
- **Proxima acao exata:** o LUDUS Planner delimita GAME-007 (aparo), verificando se controle, janela e efeito podem ser definidos com seguranca ou se exigem decisao do usuario.

## Tarefa concluida mais recente

- **ID:** GAME-007
- **Nome:** Implementar bloqueio/aparo compartilhados
- **Status:** CONCLUIDA — validada pelo usuario.
- **Responsavel:** LUDUS Planner, coordenado pelo LUDUS Coordinator.
- **Pedido:** usuario relatou que nao percebeu feedback visual/nem conseguiu acertar aparo e pediu que bloqueio/aparo usem o mesmo comando; confirmou botao direito do mouse.
- **Objetivo:** entregar defesa unificada, distinguivel e testavel contra o ataque basico do inimigo.
- **Escopo:** unificar bloqueio e aparo no botao direito; toque dentro dos ultimos 0,3 s do telegrapho faz aparo; manter pressionado ate o impacto fora do sucesso de aparo bloqueia; aparo interrompe o golpe e manda o inimigo para recuperacao; feedback visual claro para janela, bloqueio e sucesso.
- **Fora de escopo:** stamina, punicao adicional, outros tipos de ataque e balanceamento definitivo.
- **Criterio de conclusao:** botao direito executa ambos; janela de 0,3 s e indicada visualmente; toque nessa janela cancela golpe e inicia recuperacao; segurar atraves do impacto fora de aparo bloqueia; soltar antes causa dano; movimento/ataque continuam funcionando.
- **Arquivos inspecionados pelo Coordinator:** `project.godot`, `scripts/player.gd`, `scripts/enemy.gd`, `scenes/arena.tscn`, `docs/DECISOES.md`, `docs/GUIA_DE_DESENVOLVIMENTO.md` e instrucoes do projeto. Godot 4.7; inimigo ataca na entrada de `ATTACKING`.
- **Decisao aprovada pelo usuario:** comando de bloqueio/aparo e botao direito do mouse; toque no timing = aparo, manter ate o impacto = bloqueio; janela proposta de 0,3 s antes do golpe; sucesso cancela o golpe e leva o inimigo a recuperacao.
- **Nota de implementacao anterior:** Space tinha aro azul enquanto segurado e aro branco breve quando bloqueava; aparo e seu indicador de timing ainda nao existiam.
- **Reavaliacao de GAME-006:** manter confirmacao funcional anterior, mas considerar feedback visual insuficientemente claro conforme relato posterior; GAME-007 deve tornar janela e sucessos de defesa mais visiveis.
- **Arquivos alterados:** `project.godot`, `scripts/player.gd`, `scripts/enemy.gd`, `docs/DECISOES.md`, `docs/GUIA_DE_DESENVOLVIMENTO.md`, este estado e diario. `.vscode/` nao rastreada nao foi alterada nem incluida.
- **Validacoes:** importacao e smoke da arena por 240 frames no Godot 4.7.2 passaram; teste GDScript focado passou para aparo, bloqueio, toque precoce mantido ate bloquear, dano sem defesa, movimento e ataque; `git diff --check` passou. A primeira tentativa do teste focado nao aguardou o frame de `just_pressed`; apos corrigir a sincronizacao do harness, o teste passou. Usuario confirmou que a validacao visual foi feita.
- **Ultimo passo concluido:** usuario informou “Validacao visual está feita”; feedback do aparo/bloqueio aceito.
- **Arquivos da tarefa modificados:** `project.godot`, `scripts/player.gd`, `scripts/enemy.gd`, `docs/DECISOES.md`, `docs/GUIA_DE_DESENVOLVIMENTO.md`, `docs/ESTADO_ATUAL.md` e entrada GAME-007 em `docs/DIARIO_DE_DESENVOLVIMENTO.md`. A alteracao preexistente de `.vscode/` foi preservada e excluida.
- **Commit/push:** `4f2e744` — `feat: add shared block and parry`; enviado para `origin/main`.
- **Proxima acao exata:** o LUDUS Planner delimita uma esquiva minima com base no combate atual; nao escolher controle ou invulnerabilidade sem verificar se sao essenciais.

## Tarefa ativa

- **ID:** GAME-008
- **Nome:** Implementar esquiva basica
- **Status:** CONCLUIDA — implementacao, verificacoes tecnicas e validacao visual humana concluidas.
- **Responsavel:** LUDUS Coordinator; plano do LUDUS Planner, implementacao do LUDUS Developer e checklist do LUDUS Playtester concluidos.
- **Pedido:** implementar roll de esquiva com invulnerabilidade breve usando a barra de espaco.
- **Objetivo:** permitir uma esquiva curta e legivel integrada ao combate top-down atual.
- **Escopo aprovado:** Space inicia roll na direcao do input de movimento ou, sem input, na ultima direcao valida; duracao inicial de 0,2 s, velocidade de 1,5x o movimento normal e recarga provisoria de 0,6 s; invulnerabilidade somente durante o roll; sem stamina.
- **Fora de escopo:** novas armas, progressao, stamina/custo, balanceamento amplo e o problema conhecido de empurrao/arrasto do inimigo documentado em `docs/BUGS.md`.
- **Criterio de conclusao:** roll respeita colisoes e limites da arena, nao recebe dano durante sua janela, recebe dano fora dela, tem feedback observavel e preserva ataque/bloqueio/aparo.
- **Arquivos de implementacao alterados:** `project.godot` e `scripts/player.gd`. Testes temporarios especificos em `scripts/game_008_smoke_test.gd` e `scenes/game_008_smoke_test.tscn` foram removidos apos a execucao.
- **Validacoes:** Godot 4.7.2 headless importou o projeto e executou a arena por 240 frames sem erros; teste focado com `--fixed-fps 60` passou para direcao atual/ultima direcao, velocidade, duracao, cooldown antes/depois de expirar, dano durante/fora da esquiva, colisao com limite e ataque/bloqueio/aparo; `git diff --check` e diagnostico do GDScript passaram. Usuario confirmou validacao visual: "Deu certo".
- **Git confirmado antes do trabalho:** `main` e `origin/main` em `c7f00c8`. Alteracoes locais preexistentes em estado/diario e nao rastreados `.vscode/` e `docs/BUGS.md` preservados e fora do escopo de commit.
- **Plano tecnico confirmado:** implementado em `project.godot` e `scripts/player.gd`; `scripts/enemy.gd` permaneceu inalterado. O roll usa `move_and_slide`, ignora dano somente enquanto ativo e desenha aro, indicador de direcao e texto "ROLL".
- **Checklist manual recebida:** testar Space parado, apos direcao anterior e junto com WASD; cooldown antes/depois de 0,6 s; dano em impacto durante e fora do roll; barreiras; ataque e defesa antes/depois. Observar aro, progresso, direcao e texto "ROLL".
- **Commit:** `8a4603d` — `feat: add directional dodge`; incluiu somente os seis arquivos da GAME-008.
- **Push:** enviado para `origin/main`; branches sincronizadas. `.vscode/` e `docs/BUGS.md` ficaram fora.
- **Proxima acao exata:** encerrar por hoje; na proxima sessao, retomar a sequencia do guia apos esquiva e escolher a proxima tarefa de combate.

## Atualizacao mais recente — GAME-008

- **Pedido:** implementar e validar visualmente roll de esquiva iniciado por Space.
- **Responsavel:** LUDUS Coordinator.
- **Resultado:** esquiva com invulnerabilidade breve implementada e aceita em teste visual; sem alteracoes no inimigo.
- **Validacao visual:** usuario confirmou em 2026-10-14 que o roll funcionou.
- **Conclusao:** commit `8a4603d` criado e enviado a `origin/main`; branch sincronizada.
- **Proximo passo exato:** selecionar o proximo incremento conforme a ordem do guia; nenhum outro trabalho foi iniciado antes desta retomada.

## Tarefa concluida mais recente — GAME-009 (armas e troca)

- **Status:** CONCLUIDA — implementacao, verificacoes tecnicas e validacao funcional manual aceitas pelo usuario.
- **Responsavel:** LUDUS Coordinator, com delimitacao do LUDUS Planner, implementacao do LUDUS Developer e criterios manuais do LUDUS Playtester.
- **Pedido:** implementar duas armas — espada de curto alcance e rapida, lanca de alcance maior e mais lenta — com alternancia pela tecla `Q`, mantendo o inimigo placeholder atual como alvo de teste.
- **Objetivo:** tornar observavel uma diferenca entre os dois conjuntos de ataque e permitir alternar entre eles durante a luta.
- **Escopo:** ajustar o ataque de proximidade existente para ter parametros proprios de alcance/ritmo por arma; permitir alternancia em `Q`; mostrar claramente a arma atual; preservar o inimigo placeholder e os controles/comportamentos de movimento, esquiva, bloqueio e aparo. Sem arte definitiva, inventario, durabilidade ou ajustes de IA do inimigo.
- **Criterio de conclusao:** cada arma apresenta alcance e ritmo distintos de forma verificavel; `Q` alterna entre elas; o ataque continua aplicando dano ao inimigo no alcance correspondente; os sistemas atuais permanecem intactos; verificacao estatica passa e o usuario recebe passos de teste no Godot.
- **Decisoes aprovadas pelo pedido atual:** espada + lanca; espada mais rapida/curta; lanca mais lenta/longa; `Q` para trocar; manter inimigo placeholder.
- **Contexto verificado:** GAME-008 concluida/publicada em `8a4603d`; `project.godot` declara Godot 4.7; `scripts/player.gd` atualmente usa alcance/dano em constantes e uma acao `attack`; `scripts/enemy.gd` implementa o inimigo funcional placeholder; ambas as cenas estao em `scenes/arena.tscn`.
- **Alteracoes locais protegidas:** `project.godot` tem diferenca local de formatacao no texto das acoes de entrada; `.vscode/` e `docs/BUGS.md` estao nao rastreados. Autoria/escopo nao estabelecidos; nao alterar nem incluir.
- **Ultimo passo concluido:** leituras obrigatorias, status Git, commit, configuracao Godot, decisoes, guia, historico e scripts de jogador/inimigo conferidos.
- **Delimitacao do Planner:** reutilizar o ataque de proximidade e estruturar apenas parametros por arma; manter o dano atual igual, verificar a cadencia existente (nao ha cooldown no script inspecionado), evitar que alternar burle a cadencia e nao alterar IA. Valores temporarios iniciais definidos para teste: espada 48 px e intervalo de 0,35 s; lanca 80 px e intervalo de 0,7 s. O ataque continua com dano 1.
- **Arquivos esperados:** `scripts/player.gd`, `project.godot` (mapeamento de entrada Q); atualizacao documental de decisao/guia pelo Coordinator. Nao alterar `scripts/enemy.gd` ou cenas existentes sem necessidade tecnica demonstrada.
- **Implementacao entregue pelo Developer:** `scripts/player.gd` agora alterna espada/lança e usa alcance/cadencia por arma, mantendo dano 1 e cooldown ao trocar; `project.godot` mapeia `switch_weapon` para Q. A arma equipada e o raio do ataque sao exibidos.
- **Valores temporarios:** espada 48 px / 0,35 s; lança 80 px / 0,70 s; dano 1 para ambas.
- **Verificacoes tecnicas do Coordinator:** `E:\\Godot_v4.7.2-stable_win64.exe --headless --path E:\\Ludus --editor --quit` importou sem erros; `--headless --path E:\\Ludus --quit-after 240` executou a cena principal por 240 frames sem erros; `git diff --check` passou. A revisao do diff confirma que o inimigo nao foi alterado. Esses testes nao simulam entrada de jogador nem substituem playtest.
- **Playtester:** roteiro preparado, nao executado. Verificar indicador ESPADA/LANCA ao pressionar Q; comparacao a aproximadamente 40/60/90 px (ambas/so lanca/nenhuma, respectivamente); cadencia aproximada de 0,35/0,70 s; trocar durante cooldown sem disparar ataque extra; regressao de movimento, esquiva, bloqueio/aparo e inimigo placeholder.
- **Ultimo passo concluido:** usuario respondeu “Certinho chat aprovado” ao receber as mudancas e o roteiro manual; conforme pedido, isso e registrado como aceite/conclusao da validacao manual. O usuario nao relatou falha.
- **Validacoes:** Godot 4.7.2 importou o projeto em modo headless e executou a cena principal por 240 frames sem erros; `git diff --check` passou; revisao estatica confirma que o inimigo nao foi alterado. Validacao manual aceita pelo usuario. O smoke headless nao simula entradas.
- **Alteracoes preexistentes protegidas:** diferenca local de formatacao em `project.godot`; nao rastreados `.vscode/` e `docs/BUGS.md`. A acao `switch_weapon` em Q sera isolada para commit sem incluir a formatacao preexistente.
- **Arquivos da tarefa:** `scripts/player.gd`, a acao `switch_weapon` em `project.godot`, `docs/DECISOES.md`, `docs/GUIA_DE_DESENVOLVIMENTO.md`, este checkpoint e `docs/DIARIO_DE_DESENVOLVIMENTO.md`. `scripts/enemy.gd` permaneceu inalterado.
- **Versao:** mantida em `0.1.0-pre-alpha`; criterios de promocao de estagio nao foram avaliados como satisfeitos por esta tarefa isolada.
- **Commit:** `4066734` — `feat: add sword and spear weapon swapping`, com trailer `Co-authored-by: GitHub Copilot <copilot@users.noreply.github.com>`. Inclui seis arquivos apenas; em `project.godot`, somente o mapeamento `switch_weapon` foi staged.
- **Push:** commit GAME-009 `4066734` publicado em `origin/main`. O mapeamento Q foi enviado; formatacao local anterior em `project.godot`, `.vscode/` e `docs/BUGS.md` ficaram fora.
- **Proxima acao exata:** encerrar GAME-009. Na retomada, escolher o proximo incremento de acordo com a ordem do guia, sem tarefa ativa de implementacao neste momento.
- **Entrada do diario:** GAME-009, 2026-10-14 — implementacao concluida e validacao manual aceita pelo usuario.

## Fatos estruturais confirmados

- `project.godot` tem `config/name="Novo Projeto de Jogo"` e `config/features=PackedStringArray("4.7", "Forward Plus")`.
- A arena inicial esta em `scenes/arena.tscn`, o jogador em `scenes/player.tscn` e seus scripts em `scripts/`; a cena inicial e a arena.
- `.gitignore` exclui `.godot/`, evitando versionar dados locais gerados pelo editor.
- O GDD consolidado foi copiado para `docs/referencias/LUDUS_GDD_Consolidado_v1.0.docx`; o guia resumido esta em `docs/GUIA_DE_DESENVOLVIMENTO.md`.
