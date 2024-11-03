ElevatedButton(
  onPressed = isLoading ? null : () async { // Disable button when loading
    setState(() {
      isLoading = true; // Set loading state to true
    });

    final dioClient = DioClient();
    final otpRequest = OtpRequest(
      email: 'srayansh2310022@akgec.ac.in',
      otp: int.parse(enteredOtp),
    );

    try {
      // Await the response message
      String message = await dioClient.sendOtp(otpRequest);
      print(message); // Debugging line to see the message
      // Show the success message in the Snackbar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3), // Ensure it lasts long enough
      ));
    } on ApiError catch (e) {
      // Handle API error
      setState(() {
        otperror = true;
      });
      print('API Error: ${e.error.join(', ')}'); // Debugging line
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.error.join(',')),
        duration: const Duration(seconds: 3), // Ensure it lasts long enough
      ));
    } catch (e) {
      // Handle any unexpected errors
      print('An unexpected error occurred: $e'); // Debugging line
    } finally {
      // Reset loading state after API call
      setState(() {
        isLoading = false; // Set loading state to false
      });
    }
  },
  style = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF47518C),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  child = isLoading
      ? SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
      : Text(
          'Verify',
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              color: Color(0xFFFAFAFA),
              fontWeight: FontWeight.w600,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
),
