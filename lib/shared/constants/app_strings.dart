// lib/shared/constants/app_strings.dart

/// 📝 TEXTOS PADRÃO DO APP
/// 
/// Centraliza todos os textos para facilitar:
/// - Tradução (internacionalização)
/// - Correções ortográficas
/// - Padronização de mensagens
/// 
/// USO:
/// - Text(AppStrings.appName)
/// - showSnackBar(AppStrings.errorGeneric)
class AppStrings {
  // === PRIVADO (impede instanciação) ===
  AppStrings._();

  // ===========================
  // 📱 GERAL
  // ===========================
  static const String appName = 'CompreiSomei';
  static const String appVersion = 'v1.0.0';
  static const String appTagline = 'Economize usando o CompreiSomei';

  // ===========================
  // 🔝 HEADER
  // ===========================
  static String greeting(String name) => 'Olá, $name';
  static const String balanceLabel = 'Saldo';
  static const String budgetLabel = 'Orçamento';

  // ===========================
  // 🏠 HOME PAGE
  // ===========================
  static const String homeTitle = 'Home';
  static const String capturedLabel = 'Capturado';
  static const String totalLabel = 'Total';
  static const String itemsCapturedTitle = 'Itens Capturados';
  static const String noItemsCaptured = 'Nenhum item capturado ainda';

  // ===========================
  // 🔘 BOTÕES
  // ===========================
  static const String btnConfirm = 'Confirmar';
  static const String btnCancel = 'Cancelar';
  static const String btnApply = 'Aplicar';
  static const String btnSave = 'Salvar';
  static const String btnDelete = 'Excluir';
  static const String btnClear = 'Limpar';
  static const String btnClose = 'Fechar';
  static const String btnRetry = 'Tentar Novamente';
  static const String btnContinue = 'Continuar';
  static const String btnBack = 'Voltar';

  // ===========================
  // 📸 SCANNER
  // ===========================
  static const String btnMultiply = 'Multiplicador';
  static const String btnManual = 'Manual';
  static const String clearAllPrices = 'Excluir todos';
  
  // ===========================
  // 📋 MODAIS
  // ===========================
  static const String modalManualTitle = 'Inserir valor manualmente';
  static const String modalManualHint = 'Valor (em reais)';
  static const String modalMultiplyTitle = 'Multiplicar valor';
  static const String modalMultiplyHint = 'Multiplicador';

  // ===========================
  // 🛒 LISTA DE COMPRAS
  // ===========================
  static const String listTitle = 'Lista';
  static const String listEmpty = 'Nenhum item ainda';
  static const String listEmptySubtitle = 'Capture preços com a câmera\nou adicione manualmente';
  static const String btnShare = 'Compartilhar\nLista';
  static const String btnRecipes = 'Gerar\nReceitas';
  static const String addItemTitle = 'Adicionar Item';
  static const String productNameHint = 'Nome do produto';
  static const String quantityHint = 'Quantidade';

  // ===========================
  // 📊 CATEGORIAS
  // ===========================
  static const String categoryAlimentos = 'Alimentos';
  static const String categoryLimpeza = 'Limpeza';
  static const String categoryHigiene = 'Higiene';
  static const String categoryBebidas = 'Bebidas';
  static const String categoryFrios = 'Frios';
  static const String categoryHortifruti = 'Hortifruti';

  // ===========================
  // 📰 ENCARTES
  // ===========================
  static const String encartesTitle = 'Encartes';
  static const String addEncarteTitle = 'Adicionar Encarte';
  static const String encarteNameHint = 'Nome do mercado';
  static const String encarteUrlHint = 'Link do encarte';

  // ===========================
  // 💰 ORÇAMENTO
  // ===========================
  static const String budgetTitle = 'Gastos';
  static const String budgetSetTitle = 'Definir Orçamento';
  static const String budgetInputHint = 'Digite o valor';
  static const String budgetAvailable = 'Disponível';
  static const String budgetSpent = 'Gasto';

  // ===========================
  // ⚙️ CONFIGURAÇÕES
  // ===========================
  static const String settingsTitle = 'Config.';
  static const String settingsAccount = 'Conta';
  static const String settingsNotifications = 'Notificações';
  static const String settingsTheme = 'Tema';
  static const String settingsLanguage = 'Idioma';
  static const String settingsAbout = 'Sobre';

  // ===========================
  // ✅ MENSAGENS DE SUCESSO
  // ===========================
  static const String successValueAdded = 'Valor adicionado!';
  static const String successValueCleared = 'Valor limpo.';
  static const String successBudgetUpdated = 'Orçamento atualizado!';
  static const String successItemAdded = 'Item adicionado!';
  static const String successItemDeleted = 'Item removido!';
  static const String successListShared = '✅ Lista enviada!';
  static const String successAllCleared = 'Todos os valores foram removidos!';

  // ===========================
  // ⚠️ MENSAGENS DE ERRO
  // ===========================
  static const String errorGeneric = 'Ocorreu um erro. Tente novamente.';
  static const String errorNoValue = 'Defina um valor antes de confirmar.';
  static const String errorNoMultiplier = 'Defina um valor para multiplicar.';
  static const String errorInvalidValue = 'Valor inválido!';
  static const String errorInvalidEmail = 'Digite um email válido';
  static const String errorCameraPermission = 'Permissão de câmera negada';
  static const String errorCameraInit = 'Erro ao inicializar câmera';
  static const String errorNoCamera = 'Nenhuma câmera encontrada';

  // ===========================
  // ℹ️ MENSAGENS INFORMATIVAS
  // ===========================
  static const String infoFinalizeList = 'Finalize a lista para continuar';
  static const String infoComingSoon = 'Em breve';
  static const String infoNoInternet = 'Sem conexão com a internet';
  static const String infoLoading = 'Carregando...';

  // ===========================
  // 🔐 PERMISSÕES
  // ===========================
  static const String permissionCameraTitle = 'Permissão de Câmera';
  static const String permissionCameraMessage = 
      'Precisamos de acesso à câmera para escanear preços';
  static const String permissionCameraDenied = 
      'Permissão negada permanentemente. Ative nas configurações.';
  static const String btnOpenSettings = 'Abrir Configurações';

  // ===========================
  // 🎨 DIALOGS
  // ===========================
  static const String dialogFinalizeTitle = 'Finalizar lista';
  static const String dialogFinalizeMessage = 
      'Para compartilhar, finalize a lista.';
  static const String dialogDeleteTitle = 'Confirmar exclusão';
  static const String dialogDeleteMessage = 
      'Tem certeza que deseja remover este item?';
  static const String dialogClearAllTitle = 'Limpar todos os valores?';
  static const String dialogClearAllMessage = 
      'Tem certeza que deseja apagar todos os preços?';

  // ===========================
  // 📧 COMPARTILHAR
  // ===========================
  static const String shareTitle = 'Compartilhar Lista';
  static const String shareEmailHint = 'Email';
  static const String shareSending = 'Enviando...';

  // ===========================
  // 🍳 RECEITAS
  // ===========================
  static const String recipesTitle = 'Sugestões de Receitas';
  static const String recipesGenerating = 'Gerando receitas...';
  static const String recipesError = 'Erro ao gerar receitas';
}