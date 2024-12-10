# RefactorTestingLab

<img width="864" alt="Screenshot 2024-12-10 at 11 46 05 AM" src="https://github.com/user-attachments/assets/ffa12409-0add-45bb-a669-d5488f71d889">

In this image we can see a few coding principles violated: 

1. the function registerUser is too long, we need to shorten it
     its using a if logic for all the desicions it has to make, we can shorten the logic of the if by creating a helper function that can         help vaidate these inputs

2. Both authenticateUser and registerUser are using fatalError() to handle errors in runtime. This has to be changed because it will cause the app to close whenever it falls under the fatalError line. We must change the code in this case to handle errors succesfully and avoid causing the app to crash.

3. Moved functions and classes to different files to avoid long codes
