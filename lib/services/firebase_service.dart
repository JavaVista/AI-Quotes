import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai_quotes_app/models/quote.dart';

class FirebaseService {
  final CollectionReference quotesCollection = FirebaseFirestore.instance.collection('quotes');

  Future<void> addQuote(Quote quote) {
    return quotesCollection.doc(quote.id).set(quote.toJson());
  }

  Stream<List<Quote>> getQuotes() {
    return quotesCollection.snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Quote.fromJson(doc.data() as Map<String, dynamic>)).toList()
    );
  }

  Future<void> deleteQuote(String id) {
    return quotesCollection.doc(id).delete();
  }
}
