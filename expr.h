#ifndef EXPR_H
#define EXPR_H

struct expr
{
    union
    {
        int ival;
        float fval;
    } value;
    int type; // 1 for int, 0 for float
};

#endif // EXPR_H
