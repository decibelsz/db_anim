# db_anim
animation script

## Sistema de animações para players com sincronia de objetos locais (não networked)
Possibilidade de executar animações *COM PROPS* sincronizados localmente (não podem ser criados com a flag isNetworked) com outros players e com isso diminuir por completo a responsabilidade do netcode do servidor/onesync em sincronizar os props/objetos e consequentemente diminuir a carga do lado do servidor.

## Requerimentos
- Comando "/animacao [nome_animacao]" para executar uma animação previamente registrada.
- Somente uma animação pode ser executada por vez.
- As animações podem ser executadas com flags "fullbody" ou somente "upperbody".
- As animações podem ser executadas (ex.: Pescaria) em loops ou uma única vez (ex.: Uso de um consumível do inventário).
- Lidar com máximo de adversidades possíveis: jogador morto, em ragdoll, nadando, attachment, etc.

### Exemplos/sugestões de animações com objetos
- Animação de pesca com um objeto de vara de pesca na mão do personagem
- Beber água com uma garrafa na mão
