import 'package:flutter/material.dart';

void main() => runApp(const HotelApp());

class HotelApp extends StatelessWidget {
  const HotelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      // O app agora começa na tela de Login
      home: const TelaLogin(),
    );
  }
}

// --- 1. TELA DE LOGIN ---
class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _usuarioController = TextEditingController();
  final _senhaController = TextEditingController();

  void _fazerLogin() {
    // Simulação simples de login
    if (_usuarioController.text == 'admin' && _senhaController.text == '123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardHotel()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário ou senha incorretos!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.hotel, size: 80, color: Colors.indigo),
            const Text('Hotel Admin Login', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            TextField(controller: _usuarioController, decoration: const InputDecoration(labelText: 'Usuário', border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: _senhaController, decoration: const InputDecoration(labelText: 'Senha', border: OutlineInputBorder()), obscureText: true),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(onPressed: _fazerLogin, child: const Text('Entrar')),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 2. DASHBOARD (COM ESTADO DOS QUARTOS) ---
class DashboardHotel extends StatefulWidget {
  const DashboardHotel({super.key});

  @override
  State<DashboardHotel> createState() => _DashboardHotelState();
}

class _DashboardHotelState extends State<DashboardHotel> {
  final List<Map<String, String>> checkins = [
    {'nome': 'João Silva', 'quarto': '101'},
    {'nome': 'Maria Souza', 'quarto': '202'},
  ];

  final List<Map<String, String>> checkouts = [
    {'nome': 'Carlos Lima', 'quarto': '305'},
  ];

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _quartoController = TextEditingController();

  void _mostrarFormulario() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nova Reserva'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _nomeController, decoration: const InputDecoration(labelText: 'Nome do Hóspede')),
            TextField(controller: _quartoController, decoration: const InputDecoration(labelText: 'Nº do Quarto'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (_nomeController.text.isNotEmpty && _quartoController.text.isNotEmpty) {
                setState(() {
                  checkins.add({'nome': _nomeController.text, 'quarto': _quartoController.text});
                });
                _nomeController.clear();
                _quartoController.clear();
                Navigator.pop(ctx);
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Hotelaria - Dashboard', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarFormulario,
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _criarTitulo('Check-ins do Dia'),
              _criarListaHorizontal(checkins, Colors.blue),

              const SizedBox(height: 25),

              _criarTitulo('Check-outs do Dia'),
              _criarListaHorizontal(checkouts, Colors.orange),

              const SizedBox(height: 25),

              _criarTitulo('Grid dos Quartos'),
              const SizedBox(height: 10),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: largura > 600 ? 5 : 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: const [
                  QuartoCard(numero: '101', status: 'ocupado'),
                  QuartoCard(numero: '102', status: 'livre'),
                  QuartoCard(numero: '103', status: 'sujo'),
                  QuartoCard(numero: '201', status: 'livre'),
                  QuartoCard(numero: '202', status: 'ocupado'),
                  QuartoCard(numero: '203', status: 'livre'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _criarTitulo(String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(texto, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _criarListaHorizontal(List<Map<String, String>> dados, Color cor) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dados.length,
        itemBuilder: (ctx, index) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(right: 10),
            child: Container(
              width: 150,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: cor, width: 5)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(dados[index]['nome']!, style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                  Text('Quarto ${dados[index]['quarto']}', style: TextStyle(color: cor)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class QuartoCard extends StatelessWidget {
  final String numero;
  final String status;
  const QuartoCard({super.key, required this.numero, required this.status});

  @override
  Widget build(BuildContext context) {
    Color corFundo = status == 'livre' ? Colors.green : (status == 'ocupado' ? Colors.red : Colors.orange);
    return Container(
      decoration: BoxDecoration(color: corFundo, borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.bed, color: Colors.white),
          Text(numero, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text(status, style: const TextStyle(color: Colors.white70, fontSize: 10)),
        ],
      ),
    );
  }
}