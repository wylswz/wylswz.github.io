#include <immintrin.h>
#include <iostream>


// i64
namespace avx512
{

    int _interleave_1__i64 = 0XAA; // 10101010
    int _interleave_2__i64 = 0XCC; // 11001100
    int _interleave_4__i64 = 0XF0; // 11110000

    int _interleave_1__i32 = 0XAAAA;
    int _interleave_2__i32 = 0XCCCC;
    int _interleave_4__i32 = 0XF0F0;
    int _interleave_8__i32 = 0XFF00;

    __m512i _perm_idx_1__i64()
    {
        return _mm512_set_epi64(6, 7, 4, 5, 2, 3, 0, 1);
    }

    __m512i _perm_idx_2__i64()
    {
        return _mm512_set_epi64(5, 4, 7, 6, 1, 0, 3, 2);
    }

    __m512i _perm_idx_2r__i64()
    {
        return _mm512_set_epi64(4, 5, 6, 7, 0, 1, 2, 3);
    }

    __m512i _perm_idx_4r__i64()
    {
        return _mm512_set_epi64(0, 1, 2, 3, 4, 5, 6, 7);
    }

    __m512i _perm_idx_1__i32() {}
    __m512i _perm_idx_2__i32() {}
    __m512i _perm_idx_4__i32() {}
    __m512i _perm_idx_2r__i32() {}
    __m512i _perm_idx_4r__i32() {}
    __m512i _perm_idx_8r__i32() {}


    __m512i sort_i64(__m512i vec)
    {
        {
            __m512i perm_idx = avx512::_perm_idx_1__i64();
            // Permutate original vector with given index
            __m512i vec_perm = _mm512_permutexvar_epi64(vec, perm_idx);
            __m512i min = _mm512_min_epi64(vec, vec_perm);
            __m512i max = _mm512_max_epi64(vec, vec_perm);
            vec = _mm512_mask_mov_epi64(min, avx512::_interleave_1__i64, max);
        }

        {
            __m512i perm_idx = avx512::_perm_idx_2r__i64();
            __m512i vec_perm = _mm512_permutexvar_epi64(vec, perm_idx);
            __m512i min = _mm512_min_epi64(vec, vec_perm);
            __m512i max = _mm512_max_epi64(vec, vec_perm);
            vec = _mm512_mask_mov_epi64(min, avx512::_interleave_2__i64, max);
        }

        {
            __m512i perm_idx = avx512::_perm_idx_1__i64();
            __m512i vec_perm = _mm512_permutexvar_epi64(vec, perm_idx);
            __m512i min = _mm512_min_epi64(vec, vec_perm);
            __m512i max = _mm512_max_epi64(vec, vec_perm);
            vec = _mm512_mask_mov_epi64(min, avx512::_interleave_1__i64, max);
        }

        {
            __m512i perm_idx = avx512::_perm_idx_4r__i64();
            __m512i vec_perm = _mm512_permutexvar_epi64(vec, perm_idx);
            __m512i min = _mm512_min_epi64(vec, vec_perm);
            __m512i max = _mm512_max_epi64(vec, vec_perm);
            vec = _mm512_mask_mov_epi64(min, avx512::_interleave_4__i64, max);
        }

        {
            __m512i perm_idx = avx512::_perm_idx_2__i64();
            __m512i vec_perm = _mm512_permutexvar_epi64(vec, perm_idx);
            __m512i min = _mm512_min_epi64(vec, vec_perm);
            __m512i max = _mm512_max_epi64(vec, vec_perm);
            vec = _mm512_mask_mov_epi64(min, avx512::_interleave_2__i64, max);
        }

        {
            __m512i perm_idx = avx512::_perm_idx_1__i64();
            __m512i vec_perm = _mm512_permutexvar_epi64(vec, perm_idx);
            __m512i min = _mm512_min_epi64(vec, vec_perm);
            __m512i max = _mm512_max_epi64(vec, vec_perm);
            vec = _mm512_mask_mov_epi64(min, avx512::_interleave_1__i64, max);
        }
    }

}

// g++ *.cpp -mavx512f -o main^C
int main()
{
    long long nums[8] = {1, 5, 2, 4, 7, 3, 8, 6};
    __m512i vec = _mm512_load_epi64(&nums);
    vec = avx512::sort_i64(vec);
    _mm512_store_epi64(&nums, vec);
    for (int i = 0; i < 8; i++)
    {
        std::cout << nums[i] << " " << std::endl;
    }
    return 0;
}