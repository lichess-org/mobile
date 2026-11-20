// A plain UCI binary around the engine the app plays practice on.
//
// `multistockfish` is a Flutter plugin: its engines never own the process's stdin and stdout, they
// read and write private pipes that Dart pumps over FFI. This bridge does the same pumping from a
// normal `main`, so the engine can be driven from a shell or from a test — with exactly the code,
// build flags and embedded network the app ships, which is the whole point of measuring against it
// rather than against a stockfish from a package manager.
//
// Built by build_engine.sh; see README.md.

#include <cstdio>
#include <string>
#include <thread>
#include <unistd.h>

extern "C" {
int stockfish_light_init();
int stockfish_light_main();
ssize_t stockfish_light_stdin_write(char *data);
char *stockfish_light_stdout_read();
}

int main() {
  if (stockfish_light_init() < 0) {
    fprintf(stderr, "stockfish_light_init failed\n");
    return 1;
  }
  std::thread engine([] { stockfish_light_main(); });
  // The engine's output, forwarded as it comes: a UCI client reads it line by line and any delay
  // here would look like the engine thinking.
  std::thread out([] {
    for (;;) {
      char *line = stockfish_light_stdout_read();
      if (!line) continue;
      fputs(line, stdout);
      fflush(stdout);
    }
  });
  char buf[4096];
  while (fgets(buf, sizeof(buf), stdin)) {
    std::string line = buf;
    if (line.empty() || line.back() != '\n') line += '\n';
    stockfish_light_stdin_write(const_cast<char *>(line.c_str()));
    if (line.rfind("quit", 0) == 0) break;
  }
  engine.join();
  // The reader thread is parked on a blocking read of a pipe nobody will write to again; leaving
  // it to be joined would hang the process on the way out.
  _exit(0);
}
