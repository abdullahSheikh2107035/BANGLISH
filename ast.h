#ifndef AST_H
#define AST_H

#include <vector>
#include <string>

namespace banglish {

enum class BinaryOp {
    Add, Subtract, Multiply, Divide, Modulo,
    Equal, NotEqual, Less, LessEqual, Greater, GreaterEqual,
    LogicalAnd, LogicalOr,
    Assign, PlusAssign, MinusAssign, MultiplyAssign, DivideAssign, ModuloAssign
};

enum class UnaryOp {
    Negate
};

enum class LiteralType {
    Integer, Float, String, Character, Boolean
};

struct TypeSpec {
    std::string base;
    bool isConst = false;
    bool isArray = false;
    struct Expr* arraySize = nullptr;
};

struct Expr {
    virtual ~Expr() = default;
};

struct Stmt {
    virtual ~Stmt() = default;
};

struct Program {
    std::vector<struct FunctionDecl*> functions;
    ~Program() {
        // for (auto f : functions) delete f;
    }
};

struct FunctionDecl {
    TypeSpec returnType;
    std::string name;
    std::vector<struct Param*> params;
    struct Stmt* body;
    FunctionDecl(TypeSpec rt, std::string n, struct Stmt* b) : returnType(rt), name(n), body(b) {}
    ~FunctionDecl() {
        // for (auto p : params) delete p;
        // delete body;
    }
};

struct Param {
    TypeSpec type;
    std::string name;
};

struct BlockStmt : Stmt {
    std::vector<Stmt*> statements;
    ~BlockStmt() {
        // for (auto s : statements) delete s;
    }
};

struct IfStmt : Stmt {
    Expr* condition;
    Stmt* thenBranch;
    Stmt* elseBranch;
    IfStmt(Expr* c, Stmt* t, Stmt* e) : condition(c), thenBranch(t), elseBranch(e) {}
    ~IfStmt() {
        // delete condition;
        // delete thenBranch;
        // if (elseBranch) delete elseBranch;
    }
};

struct WhileStmt : Stmt {
    Expr* condition;
    Stmt* body;
    WhileStmt(Expr* c, Stmt* b) : condition(c), body(b) {}
    ~WhileStmt() {
        // delete condition;
        // delete body;
    }
};

struct ForStmt : Stmt {
    Stmt* init;
    Expr* condition;
    Expr* increment;
    Stmt* body;
    ForStmt(Stmt* i, Expr* c, Expr* inc, Stmt* b) : init(i), condition(c), increment(inc), body(b) {}
    ~ForStmt() {
        // if (init) delete init;
        // if (condition) delete condition;
        // if (increment) delete increment;
        // delete body;
    }
};

struct ReturnStmt : Stmt {
    Expr* value;
    ReturnStmt(Expr* v) : value(v) {}
    ~ReturnStmt() { // if (value) delete value; 
    }
};

struct BreakStmt : Stmt {};

struct ContinueStmt : Stmt {};

struct ExprStmt : Stmt {
    Expr* expr;
    ExprStmt(Expr* e) : expr(e) {}
    ~ExprStmt() { // delete expr; 
    }
};

struct VariableDecl : Stmt {
    TypeSpec type;
    std::string name;
    Expr* initializer;
    VariableDecl(TypeSpec t, std::string n, Expr* i) : type(t), name(n), initializer(i) {}
    ~VariableDecl() { // if (initializer) delete initializer; 
    }
};

struct BinaryExpr : Expr {
    Expr* left;
    BinaryOp op;
    Expr* right;
    BinaryExpr(Expr* l, BinaryOp o, Expr* r) : left(l), op(o), right(r) {}
    ~BinaryExpr() {
        // delete left;
        // delete right;
    }
};

struct UnaryExpr : Expr {
    UnaryOp op;
    Expr* operand;
    UnaryExpr(UnaryOp o, Expr* opnd) : op(o), operand(opnd) {}
    ~UnaryExpr() { // delete operand; 
    }
};

struct CallExpr : Expr {
    Expr* callee;
    std::vector<Expr*> arguments;
    CallExpr(Expr* c) : callee(c) {}
    ~CallExpr() {
        // delete callee;
        // for (auto a : arguments) delete a;
    }
};

struct IndexExpr : Expr {
    Expr* array;
    Expr* index;
    IndexExpr(Expr* a, Expr* i) : array(a), index(i) {}
    ~IndexExpr() {
        // delete array;
        // delete index;
    }
};

struct VariableExpr : Expr {
    std::string name;
    VariableExpr(std::string n) : name(n) {}
};

struct LiteralExpr : Expr {
    LiteralType type;
    std::string value;
    LiteralExpr(LiteralType t, std::string v) : type(t), value(v) {}
};

struct PipeExpr : Expr {
    Expr* left;
    Expr* right;
    PipeExpr(Expr* l, Expr* r) : left(l), right(r) {}
    ~PipeExpr() {
        // delete left;
        // delete right;
    }
};

struct ArrayLiteralExpr : Expr {
    std::vector<Expr*> elements;
    ~ArrayLiteralExpr() {
        // for (auto e : elements) delete e;
    }
};

} // namespace banglish

#endif // AST_H