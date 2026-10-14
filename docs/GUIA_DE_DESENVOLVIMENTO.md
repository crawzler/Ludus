# LUDUS — Guia de desenvolvimento

Este documento transforma o GDD consolidado em um caminho de trabalho pratico para o projeto. Ele deve ser atualizado quando uma decisao de escopo for validada. O GDD continua sendo a referencia de visao e design; este guia orienta o que implementar agora.

Para retomar trabalho entre chats/agentes/aplicativos, siga `PROTOCOLO_DE_CONTINUIDADE.md`. O estado vivo fica em `ESTADO_ATUAL.md`, decisoes em `DECISOES.md`, e o historico em `DIARIO_DE_DESENVOLVIMENTO.md`. O GDD original esta em `referencias/LUDUS_GDD_Consolidado_v1.0.docx`.

## Visao do jogo

LUDUS e um action roguelite de gladiadores sobre combate em arena, improvisacao e legado. O jogador prepara combatentes e equipamento, enfrenta lutas de alto risco e transforma vitorias e derrotas em novas historias para o Ludus.

**Fantasia central:** “Eu nao controlo apenas um gladiador. Eu construo um legado.”

### Pilares

- **Combate pesado:** ataques, defesas e impactos devem comunicar peso e risco.
- **Improvisacao:** adaptar-se, trocar de arma e aproveitar oportunidades importa.
- **Legado:** gladiadores, armas e o Ludus carregam consequencias ao longo do tempo.
- **Espetaculo:** a habilidade do jogador deve ser reconhecida e recompensada.
- **Narrativa emergente:** sistemas conectados devem criar historias compreensiveis.

## Decisao tecnica inicial

- Engine: Godot 4; a versao exata deve ser lida em `project.godot`.
- Linguagem: GDScript.
- Perspectiva: arena 2D isometrica, camera fixa.
- Ferramentas do projeto: Godot Editor para cenas e execucao; VS Code e Copilot como apoio para codigo, investigacao e documentacao.
- Prioridade: recursos nativos da engine e prototipos com arte temporaria.
- Addons: nenhum e necessario para iniciar. Avaliar apenas diante de uma necessidade comprovada.

## Versionamento do jogo

- A versao do produto fica em `application/config/version` no `project.godot`; ela e diferente da versao do Godot indicada em `config/features`.
- Formato inicial: `MAJOR.MINOR.PATCH[-fase]`. O prototipo comeca em `0.1.0-pre-alpha`; a parte apos o hifen pode indicar `pre-alpha`, `alpha`, `beta` ou `rc.1`, conforme o estagio.
- Enquanto a versao for `0.x`, ela indica desenvolvimento inicial e nao promete compatibilidade estavel.
- Atualize a versao em mudancas com significado para o produto, nao em cada commit. Crie tags Git anotadas com prefixo `v` apenas em marcos/release intencionais (por exemplo, `v0.1.0-pre-alpha`); commits continuam sendo o historico de cada alteracao.
- Nao criar release/tag ate haver um marco que se queira destacar e validar.

## Escopo atual: prototipo de combate

### Incluir, em ordem

1. Movimento do jogador, arena, colisao e camera.
2. Ataque basico, dano e feedback visual/sonoro temporario.
3. Inimigo funcional e leitura dos seus ataques.
4. Vida e estados de vitoria e derrota.
5. Bloqueio.
6. Aparo com janela consistente e feedback claro.
7. Esquiva.
8. Dois conjuntos e troca de armas durante a luta.
9. Execucoes e condicao das armas.
10. HUD minimo e testes repetidos.

Essa sequencia pode mudar quando um teste revelar uma dependencia tecnica ou um problema de jogabilidade. Mantenha uma versao jogavel desde cedo.

**Regra aprovada para o prototipo atual (GAME-007):** botao direito do mouse compartilha bloqueio e aparo. Um novo pressionamento nos ultimos 0,3 segundos do telegrapho do ataque basico do inimigo executa aparo, cancela o golpe e manda o inimigo para recuperacao; manter o botao ate o impacto bloqueia se nao houve aparo. A janela deve ser sinalizada claramente, e os feedbacks de bloqueio/aparo devem ser distinguiveis. Esta regra e especifica ao prototipo atual e pode ser revisada apos playtest.

### Nao incluir ainda

- Gestao completa do Ludus, recrutamento, funcionarios e economia.
- Progressao permanente, arvore de habilidades ou campanha completa.
- Ferimentos persistentes, morte permanente, captura ou mercado.
- Chefes, animais, faccoes, narrativa extensa e multiplas arenas.
- Arte, animacoes e audio definitivos.

Esses elementos podem ser reconsiderados depois de validar o combate; nao sao criterios para concluir o prototipo.

## Marcos e criterios de saida

### Marco 0 — Projeto executavel

- O projeto abre e roda no Godot sem erros impeditivos.
- O repositorio Git esta conectado e o trabalho pode ser salvo em commits pequenos.
- Decisoes tecnicas e controles aprovados estao documentados antes de virarem dependencias.

### Marco 1 — Movimento legivel

- O jogador se move na arena e colide com limites e obstaculos previstos.
- A camera fixa permite ler posicao, personagem e espaco de combate.
- O movimento pode ser repetido sem travamentos ou perda inesperada de controle.

### Marco 2 — Primeiro combate completo

- Jogador e inimigo podem atacar e receber dano.
- O jogador consegue entender quando um ataque acertou e por que sofreu dano.
- Uma luta termina em vitoria ou derrota de maneira clara.

### Marco 3 — Decisoes de combate

- Bloqueio, aparo e esquiva tem usos distintos e feedback identificavel.
- O aparo bem-sucedido interrompe ou cria uma oportunidade clara contra o inimigo.
- O jogador consegue testar as opcoes sem depender de instrucoes externas.

### Marco 4 — Arsenal e playtest

- Trocar entre dois conjuntos de armas e util em pelo menos uma situacao observavel.
- A interface mostra apenas informacoes essenciais para lutar.
- Uma sessao de teste permite avaliar se o combate continua interessante por 15 minutos.
- Os problemas observados viram tarefas; nao se adiciona conteudo para esconder problemas do nucleo.

O primeiro playtest nao precisa esperar todos os marcos: teste cedo, assim que houver uma interacao que responda a uma pergunta concreta.

## Fluxo de trabalho com Copilot

1. Faca o pedido ao LUDUS Coordinator; ele le o checkpoint, escolhe skills e coordena os especialistas pertinentes.
2. O Coordinator registra a tarefa e o proximo passo em `ESTADO_ATUAL.md` antes de delegar.
3. Os agentes continuam a tarefa a partir do ultimo checkpoint e registram progresso suficiente para uma retomada.
4. Execute o projeto no Godot e teste a mudanca em jogo; agente nenhum deve afirmar que voce fez esse teste.
5. O Coordinator atualiza estado, decisoes (se aprovadas) e diario ao concluir, interromper ou bloquear a tarefa.
6. Revise as alteracoes. Quando a tarefa estiver concluida e validada, o Coordinator faz um commit local automatico apenas com os arquivos dela; push ao GitHub sempre exige pedido explicito.

Copilot acelera a escrita e investigacao; nao substitui a decisao de design nem a verificacao no jogo. As skills deste repositorio orientam implementacao, diagnostico e playtests. Se trocar de aplicativo, forneca o protocolo, o estado atual, as decisoes, este guia e as definicoes relevantes de agente/skill.

### Modelo de pedido

> Leia as instrucoes do repositorio. A tarefa e: [uma mudanca pequena]. O resultado esperado no jogo e: [comportamento observavel]. Primeiro inspecione os arquivos relevantes e diga o plano e quais arquivos pretende alterar. Nao amplie o escopo nem adicione addons. Depois de implementar, informe exatamente como testar no Godot e quais verificacoes nao foram possiveis.

## Criterios de validacao do prototipo

- Os controles respondem consistentemente e podem ser compreendidos.
- O jogador percebe impacto em ataques, bloqueios e acertos.
- E possivel entender por que uma defesa funcionou ou falhou.
- O aparo e desafiador, consistente e recompensador, nao aleatorio.
- A troca de armas ocorre por uma decisao util, nao apenas por obrigacao.
- Ha mais de uma estrategia viavel para lidar com os encontros.
- O combate continua interessante apos 15 minutos.

Se os criterios falharem, priorize ajustes de controle, legibilidade, ritmo e feedback antes de adicionar sistemas.

## Registro de tarefas e decisoes

- Mantenha tarefas pequenas e visiveis: **A fazer**, **Fazendo**, **Testado**.
- Toda tarefa deve ter uma condicao de verificacao observavel.
- Registre decisoes de design abertas antes de implementa-las; nao trate uma sugestao da IA como decisao aprovada.
- Atualize este guia quando o escopo ou uma decisao tecnica/design for validada.
- Salve commits pequenos com mensagens que descrevam o resultado. Nao inclua arquivos gerados, credenciais ou dados privados.

## Decisoes em aberto

- Mapeamento final de controles e suporte a controle/gamepad.
- Precisao e apresentacao da perspectiva isometrica.
- Tipos de armas e inimigos incluidos na primeira versao do prototipo.
- Frequencia e regras de ferimentos, captura, perda de itens e morte em versoes futuras.
- Escopo, economia e progressao da gestao do Ludus, a decidir somente apos validar o combate.
