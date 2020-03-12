# T1_ALESTII
O filtro de filtros de ip


## Enunciado
Você acaba de ser contratado por uma empresa de segurança que faz software para limpar filtros IP em grandes empresas. Quando um firewall é instalado ele recebe uma lista de endereços IP que devem ser bloqueados por que foram identificados como nocivos. À medida que o tempo passa novos endereços são adicionados ou alterados e de vez em quando é necessário fazer uma limpeza. A lista é simples, ela contém pares de endereços (entre 0 e 2^31) e todos os endereços entre eles devem ser bloqueados, inclusive os endereços que foram dados. Em primeiro lugar está o menor número IP que foi proibido, em seguida vem o último número IP que foi proibido. Os dois endereços são separados por um sinal "-".

793359858-872845434\\
163828202-386942572\\
860031788-1045135809\\
220012220-481960112\\
107202696-258581056\\
77865186-199064861\\
207437354-311919151\\
125701728-213021371\\
851097643-935519522\\
613234685-874907996\\
432569835-566753675\\
45389652-232145031\\
896106680-1011116869\\
272672436-491730771\\
354054836-415525648\\
436958726-539840832\\
861203282-877295410\\
837159809-839258919\\
273032866-505234870\\
135087090-305043137\\

Então, a pergunta que deve ser respondida se conhecermos a lista de endereços proibidos é:

 * Qual o tamanho da menor lista possível que bloqueia os mesmos endereços?

Resolvendo o problema ao lado teríamos como resultado a lista

45389652-566753675\\
613234685-1045135809\\

que tem comprimento 2. Você deve escrever o programa para ler listas de endereços e determinar o comprimento da menor lista possível, depois testá-lo com os arquivos colocados na página da disciplina e entregar um relatório contando:

1. Qual o problema sendo resolvido;
2. Como o problema foi modelado;
3. Como é o processo de solução, apresentando exemplos;
4. algoritmos;
5. Os resultados dos casos de teste;
6. Conclusões.