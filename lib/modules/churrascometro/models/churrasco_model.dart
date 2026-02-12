class ChurrascoModel {
  final int homens;
  final int mulheres;
  final int criancas;
  final int duracaoHoras;
  final bool bebidaAlcoolica;
  final bool paoDeAlho;
  final bool carvao;
  final bool gelo;

  const ChurrascoModel({
    this.homens = 0,
    this.mulheres = 0,
    this.criancas = 0,
    this.duracaoHoras = 4,
    this.bebidaAlcoolica = true,
    this.paoDeAlho = true,
    this.carvao = true,
    this.gelo = true,
  });

  ChurrascoModel copyWith({
    int? homens,
    int? mulheres,
    int? criancas,
    int? duracaoHoras,
    bool? bebidaAlcoolica,
    bool? paoDeAlho,
    bool? carvao,
    bool? gelo,
  }) {
    return ChurrascoModel(
      homens: homens ?? this.homens,
      mulheres: mulheres ?? this.mulheres,
      criancas: criancas ?? this.criancas,
      duracaoHoras: duracaoHoras ?? this.duracaoHoras,
      bebidaAlcoolica: bebidaAlcoolica ?? this.bebidaAlcoolica,
      paoDeAlho: paoDeAlho ?? this.paoDeAlho,
      carvao: carvao ?? this.carvao,
      gelo: gelo ?? this.gelo,
    );
  }

  // Cálculos base
  double get carneTotalKg {
    // 400g por homem, 300g por mulher, 150g por criança (base 4h)
    // Se passar de 4h, aumenta 20%
    double base = (homens * 0.4) + (mulheres * 0.3) + (criancas * 0.15);
    return duracaoHoras > 4 ? base * 1.2 : base;
  }

  double get cervejaTotalLitros {
    if (!bebidaAlcoolica) return 0;
    // 1.5L por adulto (homens e mulheres)
    // Se passar de 4h, aumenta 30%
    double base = (homens + mulheres) * 1.5;
    return duracaoHoras > 4 ? base * 1.3 : base;
  }

  double get refrigeranteTotalLitros {
    // 500ml por pessoa (incluindo crianças)
    double base = (homens + mulheres + criancas) * 0.5;
    return duracaoHoras > 4 ? base * 1.2 : base;
  }

  int get paoDeAlhoUnidades {
    if (!paoDeAlho) return 0;
    // 2 unidades por adulto, 1 por criança
    int totalUnidades = (homens * 2) + (mulheres * 2) + (criancas * 1);
    // Assumindo pacote com 5 unidades (média de mercado)
    return (totalUnidades / 5).ceil(); // Retorna número de pacotes
  }

  int get carvaoSacos {
    if (!carvao) return 0;
    // 1kg de carvão assa aprox 1.5kg de carne
    double carvaoNecessarioKg = carneTotalKg / 1.5;
    // Assumindo saco de 5kg
    return (carvaoNecessarioKg / 5).ceil();
  }

  int get geloSacos {
    if (!gelo) return 0;
    // 1 saco de 5kg para cada 10 pessoas
    int totalPessoas = homens + mulheres + criancas;
    if (totalPessoas == 0) return 0;
    return (totalPessoas / 10).ceil();
  }
}
