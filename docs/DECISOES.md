# LUDUS — Registro de decisoes

Registre aqui somente decisoes aprovadas pelo usuario ou validadas em teste. Use data, contexto e impacto. Sugestoes da IA ficam em "Pendentes" e nao autorizam implementacao.

## Decisoes aprovadas

| ID | Data | Decisao | Motivo/impacto |
|---|---|---|---|
| DEC-001 | 2026-10-14 | Engine inicial: Godot 4 com GDScript. | Adequado ao projeto isometrico 2D e ao fluxo de trabalho iniciante; confirmar a versao instalada antes de usar APIs especificas. |
| DEC-002 | 2026-10-14 | Validar primeiro um prototipo de combate; gestao, progressao e conteudo amplo ficam para depois. | Preserva o escopo e os criterios do GDD consolidado. |
| DEC-003 | 2026-10-14 | Perspectiva planejada para o jogo: 2D isometrica com camera fixa. | Direcao de longo prazo do GDD; o primeiro prototipo temporario pode usar visao superior simples enquanto movimento e colisao sao validados. |
| DEC-004 | 2026-10-14 | O repositorio GitHub `crawzler/Ludus` e o local remoto do projeto. | `origin` configurado para HTTPS; commits/push continuam sujeitos a autorizacao do usuario. |
| DEC-005 | 2026-10-14 | A primeira arena de prototipo aceita pelo usuario e retangular, em visao de cima, com jogador temporario circular, movimento WASD e colisao nas bordas. | Escopo visual temporario validado para comecar o Marco 1; nao substitui a perspectiva isometrica planejada nem define controles futuros se a camera girar. |
| DEC-006 | 2026-10-14 | No prototipo atual, botao direito do mouse e a acao compartilhada de defesa: pressionar durante os ultimos 0,3 s do telegrapho do ataque basico do inimigo executa aparo; manter pressionado ate o impacto bloqueia se o aparo nao ocorreu. | O aparo cancela o golpe e envia o inimigo para recuperacao; a janela e o resultado de cada defesa devem ter feedback visual distinguivel. Regra temporaria do prototipo, sujeita a playtest e balanceamento. |
| DEC-007 | 2026-10-14 | Adotar `0.1.0-pre-alpha` como versao inicial do prototipo e o formato `MAJOR.MINOR.PATCH[-fase]`; criar tags GitHub apenas para marcos/releases, com prefixo `v`. | Distingue a versao do produto da versao do Godot e comunica que o jogo ainda esta em pre-alpha; nao cria uma release/tag a cada commit. |
| DEC-008 | 2026-10-14 | O Coordinator decide autonomamente quando criterios documentados justificam atualizar versao, estagio (pre-alpha/alpha/beta/release) ou tag; deve avisar o usuario antes da acao, explicando proposta e evidencia, e pode prosseguir sem nova aprovacao quando estiver dentro dos criterios. | Transicoes baseadas em escopo validado, nao em calendario ou volume de commits. Antes de tag/release, o commit alvo deve estar validado e publicado; tags anotadas sao para marcos. |
| DEC-008 | 2026-10-14 | O Coordinator decide autonomamente quando promover o estagio (pre-alpha/alpha/beta/release), atualizar a versao ou criar tag, aplicando os criterios do guia; deve avisar o usuario antes de cada acao, com justificativa e marco/evidencia. | Evita pedir aprovacao repetida para mudancas de versao ja delegadas, mantendo transparencia. Nao promover por tempo ou numero de commits; criar/enviar tag anotada apenas para commit validado e publicado. |

## Pendentes de decisao

| ID | Pergunta | Quando decidir |
|---|---|---|
| DEC-P01 | Qual sera o nome de exibicao final do projeto no Godot? | Antes de polir a configuracao e identidade do projeto. |
| DEC-P02 | Como os controles devem responder se camera ou mundo girarem, ou quando a perspectiva isometrica for implementada (eixos da tela ou eixos do mundo)? | Antes de implementar rotacao de camera/mundo ou fechar o controlador da perspectiva isometrica. |
| DEC-P03 | Quais duas armas e qual primeiro inimigo representarao o combate? | Depois de movimento e ataque basico funcionarem. |
| DEC-P04 | Havera suporte a controle/gamepad no prototipo? | Antes de fechar mapeamento de entrada. |

## Substituidas ou rejeitadas

Nenhuma registrada.
