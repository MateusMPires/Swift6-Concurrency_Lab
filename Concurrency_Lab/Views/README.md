# 🚀 Swift 6 Concurrency Lab: Pipeline & Cache Architecture

Um projeto de laboratório focado em explorar os limites e as melhores práticas da **Concorrência Moderna do Swift 6**. O objetivo deste repositório não é apenas consumir uma API, mas desenhar uma arquitetura de sincronização de dados que seja à prova de *Data Races*, escalável e focada na experiência do usuário.

## 🧠 Arquitetura e Conceitos Aplicados

Este aplicativo simula um cenário real de "Pipeline de Dados" (Fan-out / Fan-in), onde múltiplas requisições dependentes precisam ser executadas em paralelo, cacheadas na memória e exibidas na interface sem travar a Main Thread.

* **Strict Concurrency (Swift 6):** Modelos de domínio puramente `Sendable` e `nonisolated` para transitar com segurança entre threads.
* **Orquestração com `TaskGroup`:** Uso de paralelismo real para buscar dados em lote (Batch Download), otimizando drasticamente o tempo de rede.
* **Isolamento de Estado com `actor`:** Implementação de um `DataStore<T>` genérico, resolvendo o problema de *Actor Contention* e garantindo leitura/escrita segura em background.
* **Cache-First Approach:** Lógica de interface inteligente que prioriza dados em memória (Zero Latency) e oferece ao usuário a opção de forçar uma revalidação na API.
* **Cancelamento Cooperativo:** Tratamento profundo do ciclo de vida das `Tasks`, utilizando `Task.checkCancellation()` para abortar processamentos de rede instantaneamente caso a View seja desmontada ou o usuário desista.

## 🛠 Stack Tecnológico
* **Swift 6 & SwiftUI**
* **Native `URLSession`** com `async/await`
* **MVVM** (Model-View-ViewModel) orientada a eventos.

## 👨‍💻 Sobre o Desenvolvedor

**Mateus Martins** | iOS Developer & App Founder

Sou um desenvolvedor iOS com formação pela *Apple Developer Academy* e criador de aplicativos focados em produtividade e bem-estar (como o *Ecos*). Meu foco técnico está em transitar entre a criação de interfaces nativas fluidas (UI/UX) e a engenharia de arquiteturas robustas e testáveis por debaixo dos panos.

Gosto de construir produtos que não apenas funcionam, mas que escalam com segurança e entregam valor real ao usuário final.

🔗 [Conecte-se comigo no LinkedIn] (Coloque seu link aqui)
📱 [Conheça meus apps na App Store] (Coloque seu link aqui)

