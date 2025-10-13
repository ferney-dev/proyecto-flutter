import 'dart:convert';

class CallAdditionalInterest {
  final int callId;
  final int interestId;
  final Map<String, dynamic>? call;
  final Map<String, dynamic>? interest;

  CallAdditionalInterest({
    required this.callId,
    required this.interestId,
    this.call,
    this.interest,
  });

  factory CallAdditionalInterest.fromJson(Map<String, dynamic> json) =>
      CallAdditionalInterest(
        callId: json["callId"],
        interestId: json["interestId"],
        call: json["call"],
        interest: json["interest"],
      );

  Map<String, dynamic> toJson() => {
        "callId": callId,
        "interestId": interestId,
        "call": call,
        "interest": interest,
      };
}

List<CallAdditionalInterest> callAdditionalInterestsFromJson(String str) =>
    List<CallAdditionalInterest>.from(
        json.decode(str)["data"].map((x) => CallAdditionalInterest.fromJson(x)));
