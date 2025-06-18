#ifndef EXPR_H
#define EXPR_H

struct expr
{
    union
    {
        int ival; // Integer value
        float fval; // Floating-point value
    } value;
    int type; // 1 for int, 0 for float
};

#endif // EXPR_H
