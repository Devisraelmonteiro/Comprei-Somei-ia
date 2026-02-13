class ChurrascoModel {
  final int adultos;
  final int criancas;
  final int duracaoHoras;
  final bool bebidaAlcoolica;
  final bool paoDeAlho;
  final bool carvao;
  final bool gelo;

  const ChurrascoModel({
    this.adultos = 0,
    this.criancas = 0,
    this.duracaoHoras = 4,
    this.bebidaAlcoolica = true,
    this.paoDeAlho = true,
    this.carvao = true,
    this.gelo = true,
  });

  ChurrascoModel copyWith({
    int? adultos,
    int? criancas,
    int? duracaoHoras,
    bool? bebidaAlcoolica,
    bool? paoDeAlho,
    bool? carvao,
    bool? gelo,
  }) {
    return ChurrascoModel(
      adultos: adultos ?? this.adultos,
      criancas: criancas ?? this.criancas,
      duracaoHoras: duracaoHoras ?? this.duracaoHoras,
      bebidaAlcoolica: bebidaAlcoolica ?? this.bebidaAlcoolica,
      paoDeAlho: paoDeAlho ?? this.paoDeAlho,
      carvao: carvao ?? this.carvao,
      gelo: gelo ?? this.gelo,
    );
  }

  // Fator de duração: aumenta 10% a cada hora extra acima de 4h
  double get _durationFactor {
    if (duracaoHoras <= 4) return 1.0;
    return 1.0 + ((duracaoHoras - 4) * 0.1);
  }

  // Cálculos base
  double get carneTotalKg {
    // 400g por adulto, 150g por criança (base 4h)
    double base = (adultos * 0.4) + (criancas * 0.15);
    return base * _durationFactor;
  }

  double get cervejaTotalLitros {
    if (!bebidaAlcoolica) return 0;
    // 1.5L por adulto
    double base = adultos * 1.5;
    return base * _durationFactor;
  }

  double get refrigeranteTotalLitros {
    // 500ml por pessoa (incluindo crianças)
    double base = (adultos + criancas) * 0.5;
    return base * _durationFactor;
  }

  int get paoDeAlhoUnidades {
    if (!paoDeAlho) return 0;
    // 2 unidades por adulto, 1 por criança
    int totalUnidades = (adultos * 2) + (criancas * 1);
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
    int totalPessoas = adultos + criancas;
    if (totalPessoas == 0) return 0;
    return (totalPessoas / 10).ceil();
  }
}
