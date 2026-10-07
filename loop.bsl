purno suru() {
    purno sum = 0;
    ttokkhn(purno i = 0; i < 10; i += 1) {
        sum += i;
        jodi (i == 5) {
            calao;
        }
    }
    likho("sum=%d\n", sum);
    fero 0;
}
