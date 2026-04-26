
class MockEncoding:
    def encode(self, text, *args, **kwargs):
        # Rough estimation: 1 token per 4 characters
        return [0] * (len(text) // 4 + 1)
    
    def decode(self, tokens):
        return ""

def get_encoding(encoding_name):
    return MockEncoding()

def encoding_for_model(model_name):
    return MockEncoding()
