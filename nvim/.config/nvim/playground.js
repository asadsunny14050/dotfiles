function callMeByYourName(a, b) {

    for (let index = 2; index < process.argv.length; index++) {
        const element = process.argv[index];
        console.log("Hey, " + element)

    }
    return a + b
}
callMeByYourName("nigga");


