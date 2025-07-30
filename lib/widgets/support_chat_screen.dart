import 'package:flutter/material.dart';
import 'package:rastreo_app/l10n/app_localizations.dart';
import 'package:rastreo_app/theme/app_theme.dart';
import 'dart:async';
import 'dart:math' as math;

class SupportChatScreen extends StatefulWidget {
  const SupportChatScreen({super.key});

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _typingAnimationController;
  
  bool _isTyping = false;
  bool _showQuickReplies = true;
  
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: '¡Hola! 👋 Soy ARIA, tu asistente virtual de Rastreo App. ¿En qué puedo ayudarte hoy?',
      isBot: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
      messageType: MessageType.text,
    ),
  ];

  final List<String> _quickReplies = [
    '¿Dónde está mi envío?',
    'Problemas con sensor',
    'Cambiar dirección',
    'Reportar retraso',
    'Facturación',
    'Hablar con humano',
  ];

  final List<Map<String, dynamic>> _botResponses = [
    {
      'keywords': ['envío', 'paquete', 'donde', 'ubicación', 'tracking'],
      'responses': [
        'Para rastrear tu envío, necesito tu número de seguimiento. ¿Podrías proporcionármelo?',
        'Puedo ayudarte a localizar tu paquete. ¿Tienes el ID del envío a la mano?',
        'Para consultar el estado de tu envío, por favor comparte el número de tracking.',
      ],
      'actions': ['tracking_form'],
    },
    {
      'keywords': ['sensor', 'dispositivo', 'conectar', 'bluetooth'],
      'responses': [
        'Entiendo que tienes problemas con un sensor. ¿El dispositivo aparece como conectado en la app?',
        'Para solucionar problemas de sensores, primero verifica que el Bluetooth esté activado.',
        'Los problemas de sensores suelen resolverse reiniciando la conexión. ¿Has intentado esto?',
      ],
      'actions': ['sensor_troubleshoot'],
    },
    {
      'keywords': ['dirección', 'cambiar', 'destino', 'entregar'],
      'responses': [
        'Puedo ayudarte a cambiar la dirección de entrega. ¿El envío ya está en tránsito?',
        'Para modificar la dirección, necesito confirmar algunos datos de seguridad.',
        'El cambio de dirección es posible si el paquete no ha salido del centro de distribución.',
      ],
      'actions': ['address_change'],
    },
    {
      'keywords': ['retraso', 'tarde', 'demora', 'tiempo'],
      'responses': [
        'Lamento escuchar sobre el retraso. Permíteme verificar el estado actual de tu envío.',
        'Los retrasos pueden ocurrir por clima o tráfico. ¿Qué número de tracking tienes?',
        'Voy a revisar inmediatamente el estado de tu envío para darte información actualizada.',
      ],
      'actions': ['delay_report'],
    },
    {
      'keywords': ['factura', 'pago', 'costo', 'precio', 'cobro'],
      'responses': [
        'Para consultas de facturación, puedo revisar el historial de pagos. ¿Cuál es tu ID de cliente?',
        'Te ayudo con temas de facturación. ¿Necesitas una copia de alguna factura en particular?',
        'Para resolver dudas sobre cobros, necesito acceso a tu cuenta. ¿Puedes confirmar tu email?',
      ],
      'actions': ['billing_support'],
    },
    {
      'keywords': ['humano', 'agente', 'persona', 'operador'],
      'responses': [
        'Te conectaré con un agente humano. El tiempo de espera estimado es de 3-5 minutos.',
        'Entiendo que prefieres hablar con una persona. Te transfiero al siguiente agente disponible.',
        'Perfecto, te derivo con nuestro equipo de soporte. Mientras tanto, ¿puedes describir brevemente tu consulta?',
      ],
      'actions': ['human_transfer'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _typingAnimationController.repeat();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _typingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: AppTheme.accent,
              child: Icon(
                Icons.smart_toy,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ARIA - Asistente Virtual',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'En línea • Respuesta inmediata',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: () => _showCallOptions(context),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const ListTile(
                  leading: Icon(Icons.history),
                  title: Text('Historial de chats'),
                ),
                onTap: () => _showChatHistory(),
              ),
              PopupMenuItem(
                child: const ListTile(
                  leading: Icon(Icons.help),
                  title: Text('Preguntas frecuentes'),
                ),
                onTap: () => _showFAQ(),
              ),
              PopupMenuItem(
                child: const ListTile(
                  leading: Icon(Icons.rate_review),
                  title: Text('Calificar servicio'),
                ),
                onTap: () => _showRating(),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Lista de mensajes
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          
          // Respuestas rápidas
          if (_showQuickReplies) _buildQuickReplies(),
          
          // Campo de entrada
          _buildMessageInput(localizations),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: message.isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (message.isBot) ...[
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.accent,
              child: Icon(
                Icons.smart_toy,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isBot ? Colors.grey[100] : AppTheme.primaryMedium,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(message.isBot ? 4 : 16),
                  bottomRight: Radius.circular(message.isBot ? 16 : 4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.messageType == MessageType.text)
                    Text(
                      message.text,
                      style: TextStyle(
                        color: message.isBot ? AppTheme.primaryDark : Colors.white,
                        fontSize: 14,
                      ),
                    )
                  else if (message.messageType == MessageType.action)
                    _buildActionMessage(message),
                  
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color: message.isBot 
                          ? Colors.grey[600] 
                          : Colors.white.withOpacity(0.7),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!message.isBot) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.primaryDark,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionMessage(ChatMessage message) {
    switch (message.action) {
      case 'tracking_form':
        return _buildTrackingForm();
      case 'sensor_troubleshoot':
        return _buildSensorTroubleshoot();
      case 'address_change':
        return _buildAddressChangeForm();
      default:
        return Text(message.text);
    }
  }

  Widget _buildTrackingForm() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Formulario de Tracking',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryDark,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Ingresa tu número de tracking',
              isDense: true,
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              _handleTrackingSubmit(value);
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _handleTrackingSubmit('TN-2024-001'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryMedium,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Buscar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSensorTroubleshoot() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Solución de Problemas - Sensor',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pasos recomendados:',
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 4),
          const Text('1. Verificar que el Bluetooth esté activado'),
          const Text('2. Reiniciar la conexión del sensor'),
          const Text('3. Comprobar el nivel de batería'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _sendBotMessage('He seguido los pasos pero sigue sin funcionar.'),
                  child: const Text('No funciona'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _sendBotMessage('¡Perfecto! Ya funciona correctamente.'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.success,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Solucionado'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddressChangeForm() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cambio de Dirección',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryDark,
            ),
          ),
          const SizedBox(height: 8),
          const TextField(
            decoration: InputDecoration(
              hintText: 'Nueva dirección de entrega',
              isDense: true,
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _sendBotMessage('Perfecto, he actualizado la dirección de entrega. Te enviaré una confirmación por email.'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryMedium,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Confirmar cambio'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppTheme.accent,
            child: Icon(
              Icons.smart_toy,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _typingAnimationController,
                  builder: (context, child) {
                    return Row(
                      children: List.generate(3, (index) {
                        final delay = index * 0.3;
                        final opacity = (math.sin((_typingAnimationController.value * 2 * math.pi) + delay) + 1) / 2;
                        return Container(
                          margin: const EdgeInsets.only(right: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(opacity * 0.8),
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                    );
                  },
                ),
                const SizedBox(width: 8),
                Text(
                  'ARIA está escribiendo...',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickReplies() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Respuestas rápidas:',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: _quickReplies.map((reply) {
              return ActionChip(
                label: Text(
                  reply,
                  style: const TextStyle(fontSize: 12),
                ),
                onPressed: () => _sendMessage(reply),
                backgroundColor: AppTheme.surface.withOpacity(0.5),
                labelStyle: const TextStyle(color: AppTheme.primaryDark),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(AppLocalizations localizations) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () => _showAttachmentOptions(),
            color: AppTheme.primaryMedium,
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: localizations.typeMessage,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: (text) {
                if (text.trim().isNotEmpty) {
                  _sendMessage(text.trim());
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton.small(
            onPressed: () {
              final text = _messageController.text.trim();
              if (text.isNotEmpty) {
                _sendMessage(text);
              }
            },
            backgroundColor: AppTheme.primaryMedium,
            foregroundColor: Colors.white,
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isBot: false,
        timestamp: DateTime.now(),
        messageType: MessageType.text,
      ));
      _showQuickReplies = false;
    });

    _messageController.clear();
    _scrollToBottom();
    
    // Simular respuesta del bot
    _simulateBotResponse(text);
  }

  void _sendBotMessage(String text, {String? action}) {
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _isTyping = true;
      });
      _scrollToBottom();
    });

    Timer(const Duration(seconds: 2), () {
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          text: text,
          isBot: true,
          timestamp: DateTime.now(),
          messageType: action != null ? MessageType.action : MessageType.text,
          action: action,
        ));
      });
      _scrollToBottom();
    });
  }

  void _simulateBotResponse(String userMessage) {
    final message = userMessage.toLowerCase();
    
    // Buscar respuesta apropiada
    for (final response in _botResponses) {
      final keywords = response['keywords'] as List<String>;
      if (keywords.any((keyword) => message.contains(keyword))) {
        final responses = response['responses'] as List<String>;
        final actions = response['actions'] as List<String>;
        
        final selectedResponse = responses[math.Random().nextInt(responses.length)];
        final selectedAction = actions.isNotEmpty ? actions.first : null;
        
        _sendBotMessage(selectedResponse, action: selectedAction);
        return;
      }
    }
    
    // Respuesta por defecto
    final defaultResponses = [
      'Entiendo tu consulta. ¿Podrías darme más detalles para ayudarte mejor?',
      'Gracias por contactarnos. ¿En qué específicamente puedo asistirte?',
      'Para brindarte la mejor ayuda, ¿podrías especificar tu consulta?',
      'Estoy aquí para ayudarte. ¿Podrías reformular tu pregunta?',
    ];
    
    final selectedDefault = defaultResponses[math.Random().nextInt(defaultResponses.length)];
    _sendBotMessage(selectedDefault);
  }

  void _scrollToBottom() {
    Timer(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Ahora';
    }
  }

  void _handleTrackingSubmit(String trackingNumber) {
    _sendBotMessage(
      '¡Perfecto! He encontrado tu envío $trackingNumber.\n\n'
      '📦 Vino Tinto Reserva\n'
      '📍 Ubicación actual: En tránsito hacia Ciudad de México\n'
      '🚛 Estado: En camino\n'
      '⏰ ETA: 2 horas aproximadamente\n'
      '🌡️ Temperatura: 18°C (Óptima)\n\n'
      '¿Necesitas alguna información adicional sobre tu envío?'
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera, color: AppTheme.primaryMedium),
              title: const Text('Tomar foto'),
              onTap: () {
                Navigator.pop(context);
                _sendBotMessage('Gracias por la foto. La estoy analizando para ayudarte mejor.');
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppTheme.success),
              title: const Text('Seleccionar de galería'),
              onTap: () {
                Navigator.pop(context);
                _sendBotMessage('He recibido tu imagen. ¿Podrías explicarme qué problema estás experimentando?');
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file, color: AppTheme.warning),
              title: const Text('Adjuntar documento'),
              onTap: () {
                Navigator.pop(context);
                _sendBotMessage('Documento recibido. Lo revisaré y te daré una respuesta en breve.');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCallOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Opciones de Contacto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.phone, color: AppTheme.success),
              title: const Text('Llamar Soporte'),
              subtitle: const Text('+52 800 123 4567'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.videocam, color: AppTheme.info),
              title: const Text('Video llamada'),
              subtitle: const Text('Soporte visual en vivo'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showChatHistory() {
    // Implementar historial de chats
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Función de historial próximamente')),
    );
  }

  void _showFAQ() {
    // Implementar FAQ
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Abriendo preguntas frecuentes')),
    );
  }

  void _showRating() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Calificar Servicio'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('¿Cómo fue tu experiencia con ARIA?'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Gracias por calificar con ${index + 1} estrella${index == 0 ? '' : 's'}'),
                        backgroundColor: AppTheme.success,
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.star,
                    color: AppTheme.warning,
                    size: 32,
                  ),
                );
              }),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }
}

// Modelos de datos
class ChatMessage {
  final String text;
  final bool isBot;
  final DateTime timestamp;
  final MessageType messageType;
  final String? action;

  ChatMessage({
    required this.text,
    required this.isBot,
    required this.timestamp,
    required this.messageType,
    this.action,
  });
}

enum MessageType {
  text,
  action,
  image,
  file,
}