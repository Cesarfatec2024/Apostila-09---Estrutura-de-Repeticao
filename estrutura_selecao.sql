CREATE OR REPLACE FUNCTION valor_aleatorio_entre (lim_inferior INT, lim_superior
INT) RETURNS INT AS
$$
BEGIN
RETURN FLOOR(RANDOM() * (lim_superior - lim_inferior + 1) + lim_inferior)::INT;
END;
$$ LANGUAGE plpgsql;

--Exercicios--estrutura-de-seleção
DROP FUNCTION IF EXISTS valor_aleatorio_entre;

SELECT valor_aleatorio_entre (1, 100);

CREATE OR REPLACE FUNCTION valor_aleatorio_entre(lim_inferior INT, lim_superior INT) RETURNS INT AS
$$
BEGIN
    RETURN FLOOR(RANDOM() * (lim_superior - lim_inferior + 1) + lim_inferior)::INT;
END;
$$ LANGUAGE plpgsql;


--1.1--IF
DO $$
DECLARE
	valor INT;
BEGIN
	valor := valor_aleatorio_entre(1, 100);
	RAISE NOTICE 'O valor gerado é: %', valor;
	IF valor % 3 = 0 THEN
		RAISE NOTICE 'O valor gerado % é multiplo de 3', valor;
    	ELSE
        	RAISE NOTICE 'O valor gerado % não é multiplo de 3', valor;	
	END IF;
END;
$$
---1.1--CASE

DO $$
DECLARE
    valor INT;
BEGIN
    valor := valor_aleatorio_entre(1, 100);
    RAISE NOTICE 'O valor gerado é: %', valor;

    CASE 
        WHEN valor % 3 = 0 THEN
            RAISE NOTICE 'O valor gerado % é múltiplo de 3', valor;
        ELSE
            RAISE NOTICE 'O valor gerado % não é múltiplo de 3', valor;
    END CASE;
END;
$$ LANGUAGE plpgsql;


---1.2--IF
DO $$
DECLARE
	valor INT;
BEGIN
	valor := valor_aleatorio_entre(1, 100);
	RAISE NOTICE 'O valor gerado é: %', valor;
	IF valor % 3 = 0 THEN
		RAISE NOTICE 'O valor gerado % é multiplo de 3', valor;
    ELSIF valor % 5 = 0 THEN
		RAISE NOTICE 'O valor gerado % é multiplo de 5', valor;
	ELSE
        	RAISE NOTICE 'O valor gerado % não é multiplo de 3 nem de 5', valor;	
	END IF;
END;
$$

---1.2--CASE

DO $$
DECLARE
    valor INT;
BEGIN
    valor := valor_aleatorio_entre(1, 100);
    RAISE NOTICE 'O valor gerado é: %', valor;

    CASE 
        WHEN valor % 3 = 0 THEN
            RAISE NOTICE 'O valor gerado % é múltiplo de 3', valor;
        WHEN valor % 5 = 0 THEN
            RAISE NOTICE 'O valor gerado % é múltiplo de 5', valor;
        ELSE
            RAISE NOTICE 'O valor gerado % não é múltiplo de 3 nem de 5', valor;
    END CASE;
END;
$$ LANGUAGE plpgsql;




--1.3--IF
CREATE OR REPLACE FUNCTION realizar_operacao(op1 INT, op2 INT, operacao INT) RETURNS TEXT AS
$$
DECLARE
    resultado NUMERIC;
    operacao_texto TEXT;
BEGIN
    CASE operacao
        WHEN 1 THEN
            resultado := op1 + op2;
            operacao_texto := ' + ';
        WHEN 2 THEN
            resultado := op1 - op2;
            operacao_texto := ' - ';
        WHEN 3 THEN
            resultado := op1 * op2;
            operacao_texto := ' * ';
        WHEN 4 THEN
            IF op2 = 0 THEN
                RETURN 'Divisão por zero não é permitida.';
            ELSE
                resultado := op1 / op2;
                operacao_texto := ' / ';
            END IF;
        ELSE
            RETURN 'Operação inválida. Escolha uma operação entre 1 e 4.';
    END CASE;
    RETURN op1 || operacao_texto || op2 || ' = ' || resultado;
END;
$$ LANGUAGE plpgsql;

SELECT realizar_operacao(5, 6, 1);  
SELECT realizar_operacao(8, 4, 2);
SELECT realizar_operacao(4, 7, 3);
SELECT realizar_operacao(10, 2, 4); 

--1.3--CASE

CREATE OR REPLACE FUNCTION realizar_operacao_case(op1 INT, op2 INT, operacao INT) RETURNS TEXT AS
$$
DECLARE
    resultado NUMERIC;
    operacao_texto TEXT;
BEGIN
    CASE operacao
        WHEN 1 THEN
            resultado := op1 + op2;
            operacao_texto := ' + ';
        WHEN 2 THEN
            resultado := op1 - op2;
            operacao_texto := ' - ';
        WHEN 3 THEN
            resultado := op1 * op2;
            operacao_texto := ' * ';
        WHEN 4 THEN
            resultado := CASE
                            WHEN op2 = 0 THEN
                                NULL
                            ELSE
                                op1 / op2
                         END;
            operacao_texto := ' / ';
    ELSE
        RETURN 'Operação inválida. Escolha uma operação entre 1 e 4.';
    END CASE;
    
    IF operacao = 4 AND op2 = 0 THEN
        RETURN 'Divisão por zero não é permitida.';
    END IF;
    
    RETURN op1 || operacao_texto || op2 || ' = ' || resultado;
END;
$$ LANGUAGE plpgsql;

SELECT realizar_operacao_case(5, 6, 1);  
SELECT realizar_operacao_case(8, 4, 2);
SELECT realizar_operacao_case(4, 7, 3);
SELECT realizar_operacao_case(10, 2, 4); 
---1.4--IF

DO $$
DECLARE
    valor_compra NUMERIC := valor_aleatorio_entre(10, 30);
    valor_venda NUMERIC;
BEGIN
    IF valor_compra < 20 THEN
        valor_venda := valor_compra * 1.45;
    ELSE
        valor_venda := valor_compra * 1.30;
    END IF;
    RAISE NOTICE 'Valor de compra: % | Valor de venda: %', valor_compra, valor_venda;
END;
$$;
---1.4---CASE

DO $$
DECLARE
    valor_compra NUMERIC := valor_aleatorio_entre(10, 30);
    valor_venda NUMERIC;
BEGIN
    valor_venda := CASE 
        WHEN valor_compra < 20 THEN valor_compra * 1.45
        ELSE valor_compra * 1.30
    END;
    RAISE NOTICE 'Valor de compra: % | Valor de venda: %', valor_compra, valor_venda;
END;
$$;


---1.5-IF

DO $$
DECLARE
    salario NUMERIC := valor_aleatorio_entre(100, 2500);
    novo_salario NUMERIC;
BEGIN
    IF salario <= 400.00 THEN
        novo_salario := salario * 1.15;
    ELSIF salario <= 800.00 THEN
        novo_salario := salario * 1.12;
    ELSIF salario <= 1200.00 THEN
        novo_salario := salario * 1.10;
    ELSIF salario <= 2000.00 THEN
        novo_salario := salario * 1.07;
    ELSE
        novo_salario := salario * 1.04;
    END IF;
    RAISE NOTICE 'Salário: % | Novo Salário: %', salario, novo_salario;
END;
$$;

--1.5--CASE

DO $$
DECLARE
    salario NUMERIC := valor_aleatorio_entre(100, 2500);
    novo_salario NUMERIC;
BEGIN
    novo_salario := CASE
        WHEN salario <= 400.00 THEN salario * 1.15
        WHEN salario <= 800.00 THEN salario * 1.12
        WHEN salario <= 1200.00 THEN salario * 1.10
        WHEN salario <= 2000.00 THEN salario * 1.07
        ELSE salario * 1.04
    END;
    RAISE NOTICE 'Salário: % | Novo Salário: %', salario, novo_salario;
END;
$$;