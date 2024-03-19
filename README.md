# Tech Challenge: Infra com Terraform 

Este repositório faz parte da entrega do tech challenge - fase 3:
Contendo a infra ECS e do banco de dados com Terraform.

# Pré-requisitos

### Terraform: 
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
### AWS CLI: 
https://docs.aws.amazon.com/pt_br/cli/latest/userguide/getting-started-install.html. 

Depois de instalado, configure AWS usando o comando `aws configure`, onde será requisitado a chave secreta (secret key), que pode ser criada nessa pagina (https://us-east-1.console.aws.amazon.com/iam/home?region=us-east-1#/security_credentials) clicando em “criar chave de acesso” na aba “credenciais do AWS IAM”.

#  Abrir e rodar o projeto
O projeto foi desenvolvido no VSC (Visual Studio Code), sendo assim, instale o VSC e, na tela inicial, procure a opção extensões, ou aperte Ctrl+Shift+X, e busque por HashiCorp Terraform, assim teremos o suporte do intellisense, tornando o trabalho de escrever o código mais rápido.

Vá até a paste a abra a pasta do projeto. Após abrir o projeto abra um terminal, pode ser o integrado com o VSC, navegue até a pasta `env/Prod` e execute o comando `terraform init` dentro dela, agora temos o Terraform iniciado e podemos começar a utilizá-lo. 

Para criar a infraestrutura, execute o `terraform apply` na pastas de Produção (env/Prod).


# Organização de arquivos

Para os ambientes, ou "environments", utilizamos a pasta "env". Para infraestrutura, utilizaremos a pasta "infra". Assim, manteremos os arquivos separados reutilizando a infraestrutura independentemente do ambiente.

Subimos a infa por ambientes em vez de subir dentro da pasta infra porque assim não precisamos forncer todos os valores das variáveis que declaramos e ao executar o terraform destruct podemos ter um problema com a destruição de coisas não planejadas ou acabamos não tendo a destruição de toda a infra que criamos.

# Representação da Infraestrutura
![Infra](/docs/img/infra1.png)

# Técnicas e tecnologias utilizadas

### Provider
Um provedor é uma maneira de se comunicar com alguma ferramenta externa, podendo ser a AWS, o Google, o Kubernetes ou uma API que aceite requisições HTTP. Nesse projeto utilizaremos a AWS, que provê a infraestrutura.

### IAM
Obtamos por configurar os recursos do IAM, como o cargo e as politicas da aplicação, para previnir se acontecer alguma coisa com a aplicação e alguém conseguir um acesso indevido na nossa conta, através dessa aplicação, essa pessoa não vai conseguir acessar informações sensíveis, como senhas, bancos de dados de outras aplicações, chaves de acesso ou mesmo criar outros recursos na AWS.

### Criação de maquinas para executar containers Docker
Criação de maquinas de forma automática pelo ECS (Elastic Container Service) da AWS feito de forma automática pelo Fargate

### Elastic Constainer Registry
O repositório de containers da AWS, onde as images são armazenadas.

