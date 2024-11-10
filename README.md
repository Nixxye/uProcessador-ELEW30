# uProcessador-ELEW30

Projeto de um microprocessador desenvolvido por Jean Carlos do Nascimento Cunha e Omar Zagonel El Laden para a disciplina de **Arquitetura e Organização de Computadores** sob a orientação do Professor **Juliano Mourão Vieira**.

## Requisitos

Para executar o projeto, você precisará de:

- **GHDL** - Compilador para VHDL.
- **GTKWave** - Visualizador de waveform para análise de sinais.
- **Make** - Utilitário para automação de compilação.

## Como Usar

Para compilar e simular o microprocessador, basta abrir o terminal no diretório do projeto e digitar `make`. 

## Descrição das Instruções:
O microprocessador implementa três tipos principais de instruções: Tipo J (Jump), Tipo R (Registro) e Tipo I (Imediato). Abaixo, a descrição de cada tipo de instrução e seus campos:
### Instruções de Tipo J
As instruções do tipo Jump (J) são utilizadas para controlar o fluxo de execução do programa, realizando saltos para outros endereços de memória.
| Instruções (J) | Opcode | FUNCT | Endereço ROM (11 downto 0) |
|----------------|--------|-------|----------------------------|
| Jump           | 0001   | 000   |                            |
* Opcode: Código da operação (4 bits).
* FUNCT: Função associada ao opcode (3 bits).
* Endereço ROM: Endereço de memória de destino para a operação de salto (12 bits).
### Instruções de Tipo R
As instruções do tipo R envolvem operações aritméticas ou lógicas entre registradores. Elas utilizam os campos R0 e R1 para armazenar os operandos e resultados.
| Instruções (R) | Opcode | FUNCT | R0 (11 downto 9) | R1 (8 downto 6) |
|----------------|--------|-------|------------------|-----------------|
| ADD            | 0010   | 000   |                  |                 |
| SUB            | 0010   | 001   |                  |                 |
| MOV            | 0010   | 010   |                  |                 |
* Opcode: Código da operação (4 bits).
* FUNCT: Função específica da operação (3 bits).
* R0 e R1: Registradores envolvidos na operação (3 bits cada).
### Instruções de Tipo I
As instruções do tipo I são usadas para operações que envolvem imediatos, como adições com valores constantes ou carregamento de dados.
| Instruções (I) | Opcode | FUNCT | R0 (11 downto 9) | CTE (8 downto 0) |
|----------------|--------|-------|------------------|------------------|
| ADDI           | 0011   | 000   |                  |                  |
| LD             | 0011   | 001   |                  |                  |
* Opcode: Código da operação (4 bits).
* FUNCT: Função associada à operação (3 bits).
* R0: Registrador envolvido na operação (3 bits).
* CTE: Valor constante a ser utilizado na operação (9 bits).
