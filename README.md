# Tech Challenge: ECS com Terraform 

Este repositório faz parte da entrega do tech challenge - fase 3:
- 1 repositório para sua infra ECS com Terraform

# Pré-requisitos

### Terraform: 
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
### AWS CLI: 
https://docs.aws.amazon.com/pt_br/cli/latest/userguide/getting-started-install.html. 

Depois de instalado você pode configurar a AWS usando o comando aws configure, onde será requisitado a chave secreta (secret key), que pode ser criada nessa pagina (https://us-east-1.console.aws.amazon.com/iam/home?region=us-east-1#/security_credentials) clicando em “criar chave de acesso” na aba “credenciais do AWS IAM”.

#  Abrir e rodar o projeto
O projeto foi desenvolvido no VSC (Visual Studio Code), sendo assim, instale o VSC (pode ser uma versão mais recente) e, na tela inicial, procure a opção extensões, ou aperte Ctrl+Shift+X, e busque por HashiCorp Terraform, assim teremos o suporte do intellisense, tornando o trabalho de escrever o código mais rápido.

Vá até a paste a abra a pasta do projeto. Após abrir o projeto abra um terminal, pode ser o integrado com o VSC, navegue até a pasta env/Prod e execute o comando `terraform init` dentro dela, agora temos o Terraform iniciado e podemos começar a utilizá-lo. Para criar a infraestrutura, execute o `terraform apply` na pastas de Produção (env/Prod).

# Representação da Infraestrutura
![Infra](/docs/img/infra.png)

# Decisões tomadas

### Provider
Um provedor é uma maneira de se comunicar com alguma ferramenta externa, podendo ser a AWS, o Google, o Kubernetes ou uma API que aceite requisições HTTP. Nesse projeto utilizaremos dos provedores simultaneamente, a AWS, que provê a infraestrutura e o Kubernetes, que a configura para a aplicação.

### Organização de arquivos

Para os ambientes, ou "environments", utilizaremos a pasta "env". Para infraestrutura, utilizaremos a pasta "infra". Assim, manteremos os arquivos separados reutilizando a infraestrutura independentemente do ambiente.

Subimos a infa por ambientes em vez de subir dentro da pasta infra porque assim não precisamos forncer todos os valores das variáveis que declaramos e ao executar o terraform destruct podemos ter um problema com a destruição de coisas não planejadas ou acabamos não tendo a destruição de toda a infra que criamos.

### Arquivo de estado
Sempre que executamos o Terraform, acabamos criando um arquivo de estado, que guarda todo o estado da  infraestrutura para podermos comparar qual estado que queremos que a infraestrutura tenha com qual ela realmente tem, para podermos criar o que está faltando nela. E para podermos executar o Terraform em qualquer máquina, é interessante guardarmos esse arquivo em um local que possa ser facilmente acessado.

Nesse projeto, estamos amarzenando esse arquivo no S3 da AWS, assim, ele fica disponível para a conta usada pelo grupo e não vamos perdê-lo caso troquemos de máquina, por exemplo. Também é muito interessante fazermos isso, porque, como a maioria das rotinas de entrega contínua é executada dentro de containers docker, elas não salvam nenhum tipo de arquivo local, então salvar o estado em um serviço de cloud é benéfico.

A definição desse arquivo está no arquivo backend.tf dentro do diretório de cada ambiente.

### VPC
VPC ajuda a separar aplicações com uma camada a mais de isolamento e protege os dados de aplicações, além de permitir uma proteção extra para a aplicação, ao utilizar redes privadas. 

load balance que vamos criar vai ficar na subnet pública para que possa receber as requisições e repassá-las às instâncias que estão na subnet privada.

Na nossa região temos um internet-gateway para podermos acessar a internet para poder receber requisições e responder as requisições. Na zona de disponibilidade e dentro delas temos a rede pública com o load balancer e o NAT-gateway, e a rede privada com as instâncias ECS.

### IAM
Obtamos por configurar os recursos do IAM, como o cargo e as politicas da aplicação, para previnir se acontecer alguma coisa com a aplicação e alguém conseguir um acesso indevido na nossa conta, através dessa aplicação, essa pessoa não vai conseguir acessar informações sensíveis, como senhas, bancos de dados de outras aplicações, chaves de acesso ou mesmo criar outros recursos na AWS.
