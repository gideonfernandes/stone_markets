# StoneMarkets API


## Sobre o projeto

StoneMarkets é um projeto desenvolvido como resolução do desafio proposto pela empresa Stone e tem como finalidade a simulação de um mercado digital onde é possível que um cliente registre uma conta, realize depósitos e compras através da aplicação. O projeto foi desenvolvido utilizando a linguagem de programação Elixir e seu Framework Web mais utilizado Phoenix. A motivação para o desenvolvimento de uma API foi a possibilidade de dar um contexto real para o desafio proposto e aprimoramento dos meus conhecimentos nas tecnologias mencionadas.

Principais funcionalidades da API:
  - Listagem de moedas cadastradas
  - Listagem de marketplaces cadastrados
  - Listagem de lojistas cadastrados
  - Exibição de lojista cadastrado
  - Cadastro de clientes com conta associada
  - Exibição de cliente cadastrado
  - Autenticação de cliente
  - Deposito monetário para conta de cliente
  - Listagem de produtos cadastrados
  - Exibição de produto cadastrado
  - Atualização de moeda para um determinado marketplace, realizando o câmbio de todos os valores monetários cadastrados no sistema que possui associação com o marketplace alterado
  - Solicitação de pedido de compra por um cliente, sequenciando um split de pagamentos aos lojistas correspondentes
  - Câmbio de valor monetário entre moedas

Tecnologias e libs utilizadas na API:
  - Elixir
  - Credo
  - Ecto Eescope
  - Ecto Sql
  - Ex Coveralls
  - Ex Machina
  - Guardian
  - Hackney
  - Jason
  - Memoize
  - Mox
  - Pbkdf2 Elixir
  - Phoenix Framework
  - Phoenix Ecto
  - Plug Cowboy
  - Postgrex
  - Tesla


### Configurações de ambiente

Para executar esse projeto você precisará instalar corretamente em sua máquina o Elixir, Phoenix Framework e o Docker com uma imagem do PostgreSQL configurada. Caso ainda não os tenha instalados, siga os seguintes passos disponibilizados pela documentação oficial das tecnologias:

  - [Instalando o Elixir](https://elixir-lang.org/install.html).
  - [Instalando o Phoenix](https://hexdocs.pm/phoenix/installation.html).
  - [Instalando o Docker](https://docs.docker.com/engine/install/).

Após instalar o docker é necessário configurar a imagem do postgres, fazendo o pull da imagem oficial:

```bash
# Baixa a imagem oficial do postgres para o docker
$ sudo docker pull postgres
```

Na sequência execute o comando a seguir para subir um container com a imagem postgres recém baixada:

```bash
# Sobe um container no docker com a imagem do postgres configurada para utilização
$ sudo docker run --name stone_markets_db -p 5432:5432 -e POSTGRES_PASSWORD=postgres -e POSTGRES_USER=postgres -e POSTGRES_DB=stone_markets_dev -d postgres
```


### Configurações do projeto

Com toda a configuração de ambiente pronta, podemos então configurar nosso projeto. Primeiro passo é necessário clonar o projeto, acessando o terminal no diretório de sua preferência e executar:

```bash
# Baixa o repositório stone_markets do github
$ git clone https://github.com/gideonfernandes/stone_markets.git
```

Na sequência execute o comando 'mix deps.get' dentro do diretório do projeto para baixar as dependências:

```bash
# Acessa o projeto e baixa as dependencias necessárias
$ cd stone_markets/
$ mix deps.get
```

Após isso devemos garantir que as configurações do banco de dados estão em conformidade com as configurações do PostgreSQL que está online através do container do docker (caso você seguiu a instalação do PostgreSQL via Docker como descrito acima, estas configurações já estarão corretas) no arquivo *config/dev.exs*:

```elixir
config :stone_markets, StoneMarkets.Repo,
    username: "postgres",
    password: "postgres",
    database: "stone_markets_dev",
    hostname: "localhost",
    show_sensitive_data_on_connection_error: true,
    pool_size: 10
```

Conforme as configurações acima estiverem corretamente aplicadas, podemos então executar nosso comando de setup do projeto, no qual irá criar um banco de dados, rodar todas as migrations e seeds, deixando o projeto apto a ser utilizado.

```bash
# Executa o setup necessário para rodar o projeto
$ mix ecto.setup
```

Depois da conclusão do setup executado acima, podemos então subir nosso servidor Phoenix e utilizar nossa API rodando o comando abaixo:

```bash
# Sobe a API Phoenix
$ mix phx.server
```



## StoneMarkets em ação


### Rotas sem autenticação


#### Listagem de moedas
Descrição: Lista todas as moedas cadastradas no sistema.

- GET para localhost:4000/api/currencies


#### Listagem de marketplaces
Descrição: Lista todos os marketplaces cadastrados no sistema.

- GET para localhost:4000/api/marketplaces


#### Atualiza moeda de marketplace atual de um marketplace
Descrição: Atualiza a moeda atual do marketplace correspondente. Ao atualizar a moeda do marketplace, automaticamente todos os valores monetários cadastrados no sistema que estão linkados ao marketplace em questão serão cambeados para nova moeda e atualizados.

- PUT/PATCH para localhost:4000/api/marketplaces/:id

Passe como body da requisição o seguinte payload no formato de JSON contendo o currency_code da nova moeda que deseja utilizar no marketplace, exemplo:

```json
{"currency_code": "BRL"}
```


#### Criação de cliente/usuário
Descrição: Cria uma nova conta de acesso de cliente e automaticamente uma conta monetária com saldo inicial de 5.000,00 na moeda atual do marketplace associado, permitindo ao cliente o acesso a rotas autenticadas do sistema usando as credenciais.

- POST para localhost:4000/api/customers

Passe como payload no body da requisição um JSON no seguinte formato:

```json
{
	"address": "Rua dos Macarrões, 9999",
	"age": 23,
	"cpf":"88888888888",
	"email":"gideon.de.fernandes@gmail.com",
	"marketplace_id": "67e8afac-cffe-4f16-a3bb-ded1b532ccca",
	"name":"Gideon Fernandes",
	"nickname":"Gidex",
	"password":"123456"
}
```


#### Criação de uma autenticação na API
Descrição: Cria uma nova sessão acesso ao cliente através de suas credenciais, retornando um token JWT para utilizar nas rotas autenticadas.

- POST para localhost:4000/api/auth

Passe como payload no body da requisição um JSON no seguinte formato:

```json
{
	"email": "gideon.de.fernandes@gmail.com",
	"password": "123456"
}
```


### Rotas autenticadas

Para utilizar uma rota autenticada será necessário criar uma autenticação com as credenciais de cliente, e então utilizar o token JWT recebido como retorno no header das requisições à rota autenticada como o exemplo a seguir:

```json
{
  "header": "Beader token_gerado_pela_autenticação"
}
```


#### Depósito monetário
Descrição: Realiza o depósito de um valor monetário para a conta do cliente.

- POST localhost:4000/api/customers/:id/deposit

Passe como payload no body da requisição um JSON no seguinte formato:

```json
{
	"value": 50000
}
```

#### Exibir cliente
Descrição: Exibe o cliente correspondente ao ID solicitado.

- GET para localhost:4000/api/customer/:id


#### Listagem de lojistas
Descrição: Lista todas os lojistas cadastrados no sistema que possui associação com o marketplace em que o cliente pertence.

- GET para localhost:4000/api/shopkeepers


#### Listagem de lojistas por categoria
Descrição: Lista todas os lojistas cadastrados no sistema que pertence as categorias solicitadas e possui associação com o marketplace em que o cliente pertence.

- GET para localhost:4000/api/shopkeepers?categories="electronics,clothing"


#### Exibir lojista
Descrição: Exibe o lojista correspondente ao ID solicitado.

- GET para localhost:4000/api/shopkeeper/:id


#### Listagem de produtos
Descrição: Lista todas os produtos cadastrados no sistema que possui associação com o marketplace em que o cliente pertence.

- GET para localhost:4000/api/products


#### Listagem de produtos por categoria
Descrição: Lista todas os produtos cadastrados no sistema que pertence as categorias solicitadas e possui associação com o marketplace em que o cliente pertence.

- GET para localhost:4000/api/products?categories="electronics,clothing"


#### Exibir produto
Descrição: Exibe o produto correspondente ao ID solicitado.

- GET para localhost:4000/api/product/:id


#### Criação de um pedido de compra
Descrição: Exibe o produto correspondente ao ID solicitado.

- POST para localhost:4000/api/orders

Passe como payload no body da requisição um JSON no seguinte formato:

```json
{
	"comments": "Um comentário qualquer...",
	"marketplace_id": "67e8afac-cffe-4f16-a3bb-ded1b532ccca",
	"address": "Rua dos Macarrões, 9000",
	"products": [
		{
			"id": "961cc528-71e3-44bd-826b-29161f2c6c2b",
			"amount": 12
		},
		{
			"id": "e252526f-799a-4305-90eb-736fcf558909",
			"amount": 10
		}
	]
}
```


#### Câmbio de valor monetário
Descrição: Realiza o câmbio de valor monetário entre dus moedas.

- POST para localhost:4000/api/currencies/exchange

Passe o payload no body da requisição um JSON no seguinte formato:

```json
{
	"from_code": "BRL",
	"to_code": "EUR",
	"value": 500
}
```


#### Informações adicionais

Você poderá importar o arquivo *documentation/endpoints.json* que possui as rotas já configuradas para utilizar a API via Insomnia.

Dica de utilização:

- Importe o arquivo de rotas *documentation/endpoints.json* para o client HTTP Insomnia
- Liste os marketplaces para escolher um ID qualquer para poder criar um novo cliente
- Crie um cliente na API com seus dados para o marketplace
- Crie uma autenticação com as credenciais do cliente recém criado
- Realize um depósito para o novo cliente
- Liste todos os produtos para escolher os IDS dos produtos desejados
- Exiba o cliente logado para comparação de saldo posterior a uma compra
- Liste os lojistas comparação de saldo posterior a uma compra
- Crie um novo pedido passando os produtos desejados, quantidade e o marketplace_id do cliente
- Exiba o cliente para observar o saldo atual após uma compra
- Liste os lojistas para observar os saldos atuais após a divisão de pagamentos após uma compra
- Altere a moeda atual do marketplace que usou para criar o cliente
- Liste os lojistas para observar o cambio de valores performados após a mudança de moeda do marketplace
- Realize o câmbio de valor de uma moeda para outra
